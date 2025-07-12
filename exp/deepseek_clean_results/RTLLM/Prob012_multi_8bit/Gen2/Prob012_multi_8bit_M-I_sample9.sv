module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Zero detection for operand isolation
    wire B_zero = (B == 8'b0);
    wire A_zero = (A == 8'b0);
    
    // Generate partial products with shared terms
    wire [7:0] A_ext = A;
    wire [8:0] A_shift1 = {A_ext, 1'b0};
    wire [9:0] A_shift2 = {A_ext, 2'b0};
    wire [10:0] A_shift3 = {A_ext, 3'b0};
    wire [11:0] A_shift4 = {A_ext, 4'b0};
    wire [12:0] A_shift5 = {A_ext, 5'b0};
    wire [13:0] A_shift6 = {A_ext, 6'b0};
    wire [14:0] A_shift7 = {A_ext, 7'b0};
    
    // Generate masked partial products
    wire [15:0] pp0 = {{8{1'b0}}, A_ext} & {16{B[0] & ~B_zero}};
    wire [15:0] pp1 = {{7{1'b0}}, A_shift1} & {16{B[1] & ~B_zero}};
    wire [15:0] pp2 = {{6{1'b0}}, A_shift2} & {16{B[2] & ~B_zero}};
    wire [15:0] pp3 = {{5{1'b0}}, A_shift3} & {16{B[3] & ~B_zero}};
    wire [15:0] pp4 = {{4{1'b0}}, A_shift4} & {16{B[4] & ~B_zero}};
    wire [15:0] pp5 = {{3{1'b0}}, A_shift5} & {16{B[5] & ~B_zero}};
    wire [15:0] pp6 = {{2{1'b0}}, A_shift6} & {16{B[6] & ~B_zero}};
    wire [15:0] pp7 = {{1{1'b0}}, A_shift7} & {16{B[7] & ~B_zero}};

    // First stage: 4 carry-save adders (3:2 compressors)
    wire [15:0] s0, c0;
    assign {c0, s0} = pp0 + pp1 + pp2;
    
    wire [15:0] s1, c1;
    assign {c1, s1} = pp3 + pp4 + pp5;
    
    wire [15:0] s2, c2;
    assign {c2, s2} = pp6 + pp7 + 16'b0;
    
    // Second stage: 4:2 compressor
    wire [15:0] s3, c3;
    assign {c3, s3} = s0 + c0 + s1 + c1;
    
    // Third stage: Final adder
    wire [15:0] sum1 = s3 + c3;
    wire [15:0] sum2 = s2 + c2;
    
    // Output with operand isolation
    assign product = (A_zero | B_zero) ? 16'b0 : (sum1 + sum2);

endmodule