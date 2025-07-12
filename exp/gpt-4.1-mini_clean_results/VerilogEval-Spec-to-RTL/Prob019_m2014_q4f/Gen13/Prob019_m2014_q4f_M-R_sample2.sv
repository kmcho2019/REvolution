module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire inv_in2;

    // Invert in2 to create bubble on the input
    not u_not_inv_in2 (inv_in2, in2);

    // AND gate with in1 and inverted in2
    and u_and_out (out, in1, inv_in2);
endmodule