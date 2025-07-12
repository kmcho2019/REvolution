module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    wire not_in1, not_in2, not_in3;
    wire and1_out, and2_out, and3_out, and4_out;
    wire or1_out, or2_out;

    // XNOR implementation using basic gates
    not(not_in1, in1);
    not(not_in2, in2);
    and(and1_out, in1, in2);
    and(and2_out, not_in1, not_in2);
    or(or1_out, and1_out, and2_out);  // XNOR result

    // XOR implementation using basic gates
    not(not_in3, in3);
    and(and3_out, or1_out, not_in3);
    and(and4_out, not_in1, in3);  // Note: not_in1 reused from earlier
    or(or2_out, and3_out, and4_out);

    assign out = or2_out;

endmodule