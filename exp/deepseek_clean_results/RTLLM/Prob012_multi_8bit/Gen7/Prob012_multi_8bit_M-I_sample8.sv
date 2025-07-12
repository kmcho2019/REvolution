module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all 8 partial products with operand isolation
    wire [15:0] pp0 = B[0] ? {{8{1'b0}}, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {{7{1'b0}}, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {{6{1'b0}}, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {{5{1'b0}}, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {{4{1'b0}}, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {{3{1'b0}}, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {{2{1'b0}}, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {{1{1'b0}}, A, 7'b0} : 16'b0;

    // First stage: 4:2 compressor (carry-save)
    wire [15:0] s1, c1;
    assign s1 = pp0 ^ pp1 ^ pp2 ^ pp3;
    assign c1 = ((pp0 | pp1) & (pp2 | pp3)) << 1;

    // Second stage: 4:2 compressor (carry-save)
    wire [15:0] s2, c2;
    assign s2 = pp4 ^ pp5 ^ pp6 ^ pp7;
    assign c2 = ((pp4 | pp5) & (pp6 | pp7)) << 1;

    // Third stage: carry-save addition
    wire [15:0] s3, c3;
    assign s3 = s1 ^ s2 ^ c1;
    assign c3 = ((s1 & s2) | (s1 & c1) | (s2 & c1)) << 1;

    // Final addition: carry-propagate
    assign product = s3 + c3 + c2;

endmodule