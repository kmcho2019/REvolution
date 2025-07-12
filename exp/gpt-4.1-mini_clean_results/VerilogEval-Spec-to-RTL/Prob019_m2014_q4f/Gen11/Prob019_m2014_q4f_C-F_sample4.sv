module TopModule (
    input  in1,
    input  in2,
    output out
);

    wire in2_inv;

    // Primitive inverter for the bubble on in2
    not u_not(in2_inv, in2);

    // Primitive AND gate with in1 and inverted in2
    and u_and(out, in1, in2_inv);

endmodule