module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] bit_eq;

// Explicit bitwise XNOR for each bit
assign bit_eq = ~(A ^ B);

// Output z is high only if both bits are equal
assign z = &bit_eq;

endmodule