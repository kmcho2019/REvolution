module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Zero detection logic
    wire zero_input = (A == 8'b0) || (B == 8'b0);

    // Generate all partial products with combined shift and mask
    wire [15:0] pp[7:0];
    assign pp[0] = {8'b0, A & {8{B[0]}}};
    assign pp[1] = {7'b0, (A & {8{B[1]}}), 1'b0};
    assign pp[2] = {6'b0, (A & {8{B[2]}}), 2'b0};
    assign pp[3] = {5'b0, (A & {8{B[3]}}), 3'b0};
    assign pp[4] = {4'b0, (A & {8{B[4]}}), 4'b0};
    assign pp[5] = {3'b0, (A & {8{B[5]}}), 5'b0};
    assign pp[6] = {2'b0, (A & {8{B[6]}}), 6'b0};
    assign pp[7] = {1'b0, (A & {8{B[7]}}), 7'b0};

    // Carry-Save Adder reduction tree
    wire [15:0] s1, c1;
    wire [15:0] s2, c2;
    wire [15:0] s3, c3;

    // First level: 4 CSAs
    csa #(16) csa1(pp[0], pp[1], pp[2], s1, c1);
    csa #(16) csa2(pp[3], pp[4], pp[5], s2, c2);
    assign s3 = pp[6];
    assign c3 = pp[7];

    // Second level: 2 CSAs
    wire [15:0] s4, c4;
    wire [15:0] s5, c5;
    csa #(16) csa3(s1, c1, s2, s4, c4);
    csa #(16) csa4(c2, s3, c3, s5, c5);

    // Final adder (CPA)
    wire [15:0] sum = s4 + c4 + s5 + c5;

    always @(*) begin
        product = zero_input ? 16'b0 : sum;
    end

endmodule

// Carry-Save Adder module
module csa #(parameter WIDTH=16) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    output [WIDTH-1:0] s,
    output [WIDTH-1:0] cout
);
    assign s = a ^ b ^ c;
    assign cout = {(a[WIDTH-2:0] & b[WIDTH-2:0]) | 
                  (a[WIDTH-2:0] & c[WIDTH-2:0]) | 
                  (b[WIDTH-2:0] & c[WIDTH-2:0]), 1'b0};
endmodule