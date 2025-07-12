module TopModule(
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);

    wire or_out;  // Explicit intermediate signal for OR operation

    // Structural implementation using primitive gates
    or  (or_out, a, b);  // OR gate
    not (out, or_out);    // NOT gate (inverting the OR result)

endmodule