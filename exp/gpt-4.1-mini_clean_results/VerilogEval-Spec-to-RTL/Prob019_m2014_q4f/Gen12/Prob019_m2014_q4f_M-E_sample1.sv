module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire not_in2;

    // Invert in2 first
    not U_NOT (not_in2, in2);
    // AND gate takes in1 and inverted in2
    and U_AND (out, in1, not_in2);

endmodule