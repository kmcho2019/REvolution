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
assign out_or_logical = (|a) || (|b);

// Compute inverse of 'b' and 'a' and assign to 'out_not'
assign out_not = {~b, ~a};

endmodule