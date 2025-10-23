module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in2_inv;

// Explicit inversion to represent the bubble on in2 input of the AND gate
not u_not_in2(in2_inv, in2);

// Use continuous assignment for AND operation to aid synthesis optimizations
assign out = in1 & in2_inv;

endmodule