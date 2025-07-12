module TopModule(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Compute bitwise-OR of 'a' and 'b'
assign out_or_bitwise = a | b;

// Compute logical-OR of 'a' and 'b'
// A vector is considered true if any of its bits is 1, otherwise it's false
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Compute the NOT of 'b' and 'a'
// Place the NOT of 'b' in the upper half of out_not (bits [5:3]) and the NOT of 'a' in the lower half (bits [2:0])
assign out_not = {~b, ~a};

endmodule