module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Compute two's complement of B
wire [63:0] B_comp = ~B + 1'b1;

// Perform the addition (A + (-B))
wire [64:0] sum_ext = {1'b0, A} + {1'b0, B_comp};
wire [63:0] sum = sum_ext[63:0];

// Overflow occurs when carry-in and carry-out of MSB differ
wire carry_in = sum_ext[63];
wire carry_out = sum_ext[64];
wire ovf = carry_in ^ carry_out;

// Output assignments
assign result = sum;
assign overflow = ovf;

endmodule