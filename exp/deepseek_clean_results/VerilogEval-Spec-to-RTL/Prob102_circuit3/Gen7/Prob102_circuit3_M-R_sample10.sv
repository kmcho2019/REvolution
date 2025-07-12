module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Intermediate signals for OR operations
    wire a_or_b;
    wire c_or_d;

    // First level OR gates
    assign a_or_b = a | b;
    assign c_or_d = c | d;

    // Final AND gate
    assign q = a_or_b & c_or_d;

endmodule