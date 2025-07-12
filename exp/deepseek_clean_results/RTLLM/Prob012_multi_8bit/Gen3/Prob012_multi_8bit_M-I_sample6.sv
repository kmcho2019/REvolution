module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products with conditional generation
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Wallace tree compression
    // First stage: 3:2 compressors
    wire [15:0] sum1, carry1;
    assign {carry1, sum1} = pp0 + pp1 + pp2;
    
    wire [15:0] sum2, carry2;
    assign {carry2, sum2} = pp3 + pp4 + pp5;
    
    wire [15:0] sum3 = pp6;
    wire [15:0] sum4 = pp7;

    // Second stage: 4:2 compressor
    wire [15:0] sum_stage2, carry_stage2;
    assign {carry_stage2, sum_stage2} = sum1 + sum2 + carry1 + carry2;

    // Final addition
    wire [15:0] sum_final = sum_stage2 + sum3 + sum4 + carry_stage2;
    
    assign product = sum_final;

endmodule