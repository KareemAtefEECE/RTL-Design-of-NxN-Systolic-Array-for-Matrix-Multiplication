
///////////////////////////////// 1) PE /////////////////////////////

module PE #(
    parameter DATAWIDTH = 16
)(
    input wire clk,
    input wire rst_n,
    input wire clear,
    input wire [DATAWIDTH-1:0] a_in,
    input wire [DATAWIDTH-1:0] b_in,
    output reg [DATAWIDTH-1:0] a_out,
    output reg [DATAWIDTH-1:0] b_out,
    output reg [2*DATAWIDTH-1:0] c_out
);

// Shows the simple function of the PEs which is mult. and acc. in the same PE

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_out <= 0;
        b_out <= 0;
        c_out <= 0;
    end else if(!clear) begin
        a_out <= a_in;
        b_out <= b_in;
        c_out <= c_out + a_in * b_in;
    end
    else begin
        a_out <= 0;
        b_out <= 0;
        c_out <= 0;
    end
end
endmodule

/////////////////////////////////////////////////////////////////////////






// I have designed this general block to add regiesters to the input side according to N_SIZE

// For N_SIZE = 2 -> generats 1 stage for second row of matrix A, same is applicable for columns of matrix B
// For N_SIZE = 3 -> generats 1 stage for second row of matrix A and 2 stages for third row, same is applicable for columns of matrix B

///////////////////////////////// 2) BIT_SYNC /////////////////////////////

module BIT_SYNC #(
    parameter BUS_WIDTH = 1,
              NUM_STAGES = 2
)

(
    input wire[BUS_WIDTH-1:0] ASYNC,
    input wire CLK,
    input wire RST,
    output reg[BUS_WIDTH-1:0] SYNC
);


reg[BUS_WIDTH-1:0] q[0:NUM_STAGES-1];
integer i;

always @(posedge CLK, negedge RST) begin
    if(!RST) begin
        for(i=0;i<NUM_STAGES;i=i+1)
        q[i]<=0;
    end
    else begin
        // First Flop accepts input signal
        q[0]<=ASYNC;
        // Sifting data between stages
        for(i=1;i<NUM_STAGES;i=i+1) 
            q[i]<=q[i-1];
        
    end
end

// assigning last flop data to output
always @(*) SYNC=q[NUM_STAGES-1];

endmodule

/////////////////////////////////////////////////////////////////////



///////////////////////////////// 3) systolic_array (TOP MODULE) /////////////////////////////////


module systolic_array #(
    parameter DATAWIDTH = 16,
    parameter N_SIZE = 5
)(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [N_SIZE*DATAWIDTH-1:0] matrix_a_in,
    input wire [N_SIZE*DATAWIDTH-1:0] matrix_b_in,
    output reg valid_out,
    output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);

    //wires used for interconnections between PEs
    wire [DATAWIDTH-1:0] a[N_SIZE-1:0][N_SIZE-1:0];
    wire [DATAWIDTH-1:0] b[N_SIZE-1:0][N_SIZE-1:0];
    wire [2*DATAWIDTH-1:0] c[N_SIZE-1:0][N_SIZE-1:0];

    // Input registers that accepts matrix_a_in and matrix_b_in data
    reg [DATAWIDTH-1:0] a_in_reg[N_SIZE-1:0];
    reg [DATAWIDTH-1:0] b_in_reg[N_SIZE-1:0];

    // Output data from the regiesters for each column of matrix A (except first element) and for each row of B (except first element) 
    wire[DATAWIDTH-1:0] a_in_sync[N_SIZE-2:0];
    wire[DATAWIDTH-1:0] b_in_sync[N_SIZE-2:0];

    reg clear_pe;


    integer i,j;

// Input processing
always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < N_SIZE*2; i = i + 1) begin
                a_in_reg[i] <= 0;
                b_in_reg[i] <= 0;
            end
        end 
else begin
            if (valid_in) begin
                for (i = 0; i < N_SIZE; i = i + 1) begin
                    // extracts each element from matrix_a_in and assign it to seperate var a_in_reg starts from least to most 
                    // and same for matrix_b_in
                    // Ex: a_in_reg[0] = matrix_a_in[0 +: 4] -> bits [3:0]
                    a_in_reg[i] <= matrix_a_in[i*DATAWIDTH +: DATAWIDTH];
                    b_in_reg[i] <= matrix_b_in[i*DATAWIDTH +: DATAWIDTH];
                end
            end 
            else begin 
                // perserving the old value for valid_in = 0
              for (i = 0; i < N_SIZE; i = i + 1) begin
                a_in_reg[i] <= a_in_reg[i];
                a_in_reg[i] <= a_in_reg[i];
            end
            end

    end
    end

    // generate block used to create the instantiations of BIT_SYNC (regs) for A and B according to N_SIZE

    genvar k,m;
    generate
       for(k=0;k<N_SIZE-1;k=k+1) begin
            BIT_SYNC #(.BUS_WIDTH(DATAWIDTH),.NUM_STAGES(k+1)) sync_inst(
                .ASYNC(a_in_reg[k+1]),
                .CLK(clk),
                .RST(rst),
                .SYNC(a_in_sync[k])
            );
       end
       for(k=0;k<N_SIZE-1;k=k+1) begin
            BIT_SYNC #(.BUS_WIDTH(DATAWIDTH),.NUM_STAGES(k+1)) sync_inst(
                .ASYNC(b_in_reg[k+1]),
                .CLK(clk),
                .RST(rst),
                .SYNC(b_in_sync[k])
            );
       end
        endgenerate

     // Generate PE array instantiations
 genvar col, row;
generate
    for (row = 0; row < N_SIZE; row = row + 1) begin 
        for (col = 0; col < N_SIZE; col = col + 1) begin
            wire [DATAWIDTH-1:0] a_in_wire, b_in_wire;

                // first element accepts value from input regiester directly
            if (col == 0 && row ==0)
                assign a_in_wire = a_in_reg[row];

                // for other rows and first col accepts data coming from the BIT_SYNC (regs) outputs
            else if (col ==0 && row !=0) 
                assign a_in_wire = a_in_sync[row-1];

                // otherwise accepts the internal wire from the previous PE
            else 
                assign a_in_wire = a[row][col-1];

                // first element accepts value from input regiester directly
            if (row == 0 && col == 0)
                assign b_in_wire = b_in_reg[col];

                // for other rows and first col accepts data coming from the BIT_SYNC (regs) outputs
            else if(row == 0 && col != 0)
                assign b_in_wire = b_in_sync[col-1];

                // otherwise accepts the internal wire from the previous PE
            else   
                assign b_in_wire = b[row-1][col];

            PE #(.DATAWIDTH(DATAWIDTH)) pe_inst (
                .clk(clk),
                .rst_n(rst_n),
                .clear(clear_pe),
                .a_in(a_in_wire),
                .b_in(b_in_wire),
                .a_out(a[row][col]),
                .b_out(b[row][col]),
                .c_out(c[row][col])
            );
        end
    end
endgenerate


// Generalized control logic
reg [31:0] cycle_count;
integer row_idx;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_count <= 0;
        valid_out <= 0;
        matrix_c_out <= 0;
    end else begin
        if (cycle_count == (3 * N_SIZE + 1)) begin
         cycle_count <= 0;
         clear_pe <= 1;
        end
        // Count cycles after first valid input
        else if (valid_in || cycle_count > 0) begin
            clear_pe <= 0;
            cycle_count <= cycle_count + 1;
        end
        
        // Generate valid output at correct times
        if (cycle_count >= 2*N_SIZE && cycle_count < 3*N_SIZE) begin
            valid_out <= 1;

            // for each valid output's cycle count we start assigning each element in each row for matrix_c_out
            row_idx = cycle_count - (2*N_SIZE);
            if (row_idx < N_SIZE) begin
                for (i = N_SIZE - 1; i >= 0; i = i - 1) begin
                    matrix_c_out[(N_SIZE - 1 - i) * 2 * DATAWIDTH +: 2 * DATAWIDTH] <= c[row_idx][i];
                end
            end else begin
                matrix_c_out <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
    
end

endmodule

////////////////////////////////////////////////////////////////////////////////////////

