module TopModule (
    input  in1,
    input  in2,
    output out
);
    wire or_out;

    // Instantiate OR gate using assign (primitive or gate primitive can be used as well)
    or or_gate (or_out, in1, in2);

    // Instantiate NOT gate
    not not_gate (out, or_out);

endmodule