module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire in2_inv;

    // Built-in primitive NOT gate to create bubble on in2
    not u_not (in2_inv, in2);

    // Built-in primitive AND gate with in1 and inverted in2
    and u_and (out, in1, in2_inv);

endmodule