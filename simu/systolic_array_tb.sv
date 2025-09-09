
module systolic_array_tb;

parameter DATAWIDTH = 16;
parameter N_SIZE = 5;

reg clk;
reg rst_n;
reg valid_in;
reg [N_SIZE*DATAWIDTH-1:0] matrix_a_in;
reg [N_SIZE*DATAWIDTH-1:0] matrix_b_in;
wire valid_out;
wire [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out;

integer i;

systolic_array #(
    .DATAWIDTH(DATAWIDTH),
    .N_SIZE(N_SIZE)
) DUT(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .matrix_a_in(matrix_a_in),
    .matrix_b_in(matrix_b_in),
    .valid_out(valid_out),
    .matrix_c_out(matrix_c_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    // Initialize
    rst_n = 0;
    valid_in = 0;
    matrix_a_in = 0;
    matrix_b_in = 0;
    #20;
    
    // Release reset
    rst_n = 1;
    #10;
    
    // Feed matrix data 
    valid_in = 1;

   $display("****INPUT DATA****");

// TEST CASE FOR N_SIZE = 2


    if(N_SIZE == 2) begin
        // Cycle 1
    matrix_a_in = {16'd5, 16'd2}; 
    matrix_b_in = {16'd2, 16'd4}; 
    #10;

    $display("First Column in A : %0d , %0d",matrix_a_in[15:0],matrix_a_in[31:16]);
    $display("First Row in B : %0d , %0d",matrix_b_in[15:0],matrix_b_in[31:16]);


    // Cycle 2
    matrix_a_in = {16'd7, 16'd1}; 
    matrix_b_in = {16'd5, 16'd8}; 
    #10;

    $display("Second Column in A : %0d , %0d",matrix_a_in[15:0],matrix_a_in[31:16]);
    $display("Second Row in B : %0d , %0d",matrix_b_in[15:0],matrix_b_in[31:16]);

    // Cycle 4 (IDLE CYCLE)
    matrix_a_in = 8'b0;
    matrix_b_in = 8'b0;
    #10;

    // Cycle 5 (IDLE CYCLE)
    matrix_a_in = 8'b0;
    matrix_b_in = 8'b0;
    #10;

    valid_in = 1'b0;
    #100
    valid_in = 1'b1;

            // Cycle 1
    matrix_a_in = {16'd2, 16'd7}; 
    matrix_b_in = {16'd8, 16'd3}; 
    #10;

    $display("First Column in A : %0d , %0d",matrix_a_in[15:0],matrix_a_in[31:16]);
    $display("First Row in B : %0d , %0d",matrix_b_in[15:0],matrix_b_in[31:16]);


    // Cycle 2
    matrix_a_in = {16'd6, 16'd9}; 
    matrix_b_in = {16'd5, 16'd2}; 
    #10;

    $display("Second Column in A : %0d , %0d",matrix_a_in[15:0],matrix_a_in[31:16]);
    $display("Second Row in B : %0d , %0d",matrix_b_in[15:0],matrix_b_in[31:16]);

    // Cycle 4 (IDLE CYCLE)
    matrix_a_in = 8'b0;
    matrix_b_in = 8'b0;
    #10;

    // Cycle 5 (IDLE CYCLE)
    matrix_a_in = 8'b0;
    matrix_b_in = 8'b0;
    #10;

    valid_in = 1'b0;

    end

    // TEST CASE FOR N_SIZE = 3

    if(N_SIZE == 3) begin
    // Cycle 1
    matrix_a_in = {16'd6, 16'd9, 16'd1}; 
    matrix_b_in = {16'd9, 16'd5, 16'd4}; 
    #10;

    $display("First Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("First Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);


    // Cycle 2
    matrix_a_in = {16'd7, 16'd2, 16'd4}; 
    matrix_b_in = {16'd2, 16'd7, 16'd8}; 
    #10;

    $display("Second Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("Second Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);

    // Cycle 3
    matrix_a_in = {16'd3, 16'd5, 16'd8}; 
    matrix_b_in = {16'd3, 16'd1, 16'd7}; 
    #10;

    $display("Third Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("Third Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);

    // Cycle 4 (IDLE CYCLE)
    matrix_a_in = 12'b0;
    matrix_b_in = 12'b0;
    #10;

    // Cycle 5 (IDLE CYCLE)
    matrix_a_in = 12'b0;
    matrix_b_in = 12'b0;

    valid_in = 1'b0;
    #100
    valid_in = 1'b1;


        // Cycle 1
    matrix_a_in = {16'd6, 16'd6, 16'd7}; 
    matrix_b_in = {16'd1, 16'd5, 16'd5}; 
    #10;

    $display("First Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("First Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);

    // Cycle 2
    matrix_a_in = {16'd8, 16'd2, 16'd4}; 
    matrix_b_in = {16'd4, 16'd6, 16'd2}; 
    #10;

    $display("Second Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("Second Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);

    // Cycle 3
    matrix_a_in = {16'd1, 16'd4, 16'd8}; 
    matrix_b_in = {16'd8, 16'd3, 16'd8}; 
    #10;

    $display("Third Column in A : %0d , %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32]);
    $display("Third Row in A : %0d , %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32]);

    // Cycle 4 (IDLE CYCLE)
    matrix_a_in = 12'b0;
    matrix_b_in = 12'b0;
    #10;

    // Cycle 5 (IDLE CYCLE)
    matrix_a_in = 12'b0;
    matrix_b_in = 12'b0;

    valid_in = 1'b0;
    
    end

    // TEST CASE FOR N_SIZE = 4

    if(N_SIZE == 4) begin

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7 }; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7}; 
    #10;

    $display("First Column in A : %0d , %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48]);
    $display("First Row in B : %0d , %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7}; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7};
    #10;

    $display("Second Column in A : %0d , %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48]);
    $display("Second Row in B : %0d , %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7}; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7}; 
    #10;

    $display("Third Column in A : %0d , %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48]);
    $display("Third Row in B : %0d , %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7}; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7}; 
    #10;

    $display("Fourth Column in A : %0d , %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48]);
    $display("Fourth Row in B : %0d , %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48]);

    //(IDLE CYCLE)
    matrix_a_in = 0;
    matrix_b_in = 0;
    #10;

    //(IDLE CYCLE)
    matrix_a_in = 0;
    matrix_b_in = 0;

    valid_in = 1'b0;
    end

   
   // TEST CASE FOR N_SIZE = 5

        if(N_SIZE == 5) begin

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7,16'd7 }; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7,16'd7}; 
    #10;

    $display("First Column in A : %0d , %0d, %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48],matrix_a_in[79:64]);
    $display("First Row in B : %0d , %0d, %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48],matrix_b_in[79:64]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7,16'd7 }; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7,16'd7}; 
    #10;

    $display("Second Column in A : %0d , %0d, %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48],matrix_a_in[79:64]);
    $display("Second Row in B : %0d , %0d, %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48],matrix_b_in[79:64]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7,16'd7 }; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7,16'd7}; 
    #10;

    $display("Third Column in A : %0d , %0d, %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48],matrix_a_in[79:64]);
    $display("Third Row in B : %0d , %0d, %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48],matrix_b_in[79:64]);

    matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7,16'd7 }; 
    matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7,16'd7}; 
    #10;

    $display("Fourth Column in A : %0d , %0d, %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48],matrix_a_in[79:64]);
    $display("Fourth Row in B : %0d , %0d, %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48],matrix_b_in[79:64]);

     matrix_a_in = {16'd6, 16'd6, 16'd7,16'd7,16'd7 }; 
     matrix_b_in = {16'd1, 16'd5, 16'd5,16'd7,16'd7}; 
     #10;

    $display("Fifth Column in A : %0d , %0d, %0d, %0d, %0d",matrix_a_in[15:0],matrix_a_in[31:16],matrix_a_in[47:32],matrix_a_in[63:48],matrix_a_in[79:64]);
    $display("Fifth Row in B : %0d , %0d, %0d, %0d, %0d",matrix_b_in[15:0],matrix_b_in[31:16],matrix_b_in[47:32],matrix_b_in[63:48],matrix_b_in[79:64]);


    //(IDLE CYCLE)
    matrix_a_in = 0;
    matrix_b_in = 0;
    #10;

    //(IDLE CYCLE)
    matrix_a_in = 0;
    matrix_b_in = 0;

    valid_in = 1'b0;
    end

    // Wait for results
    #150;
    $stop;
end

// Display results
always @(posedge clk) begin
    if (valid_out) begin
        $write("Output row:");
        for (i = N_SIZE-1; i >=0; i = i - 1) begin
            $write(" %0d", matrix_c_out[(i+1)*2*DATAWIDTH-1 -: 2*DATAWIDTH]);
        end
        $display("");
    end
end
endmodule