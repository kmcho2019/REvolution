module TopModule (
    input  in1,
    input  in2,
    output out
);

wire in2_inv;

// Invert in2 to represent the bubble on the AND gate input
not U_not_in2 (in2_inv, in2);

// AND gate with one input inverted (bubble on in2)
and U_and (out, in1, in2_inv);

endmodule