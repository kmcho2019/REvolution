module TopModule (
    input  in1,
    input  in2,
    output out
);

wire not_in2;

// Explicit NOT gate instantiation to represent the bubble on in2
not u_not (not_in2, in2);

// AND gate with in1 and the inverted in2
and u_and (out, in1, not_in2);

endmodule