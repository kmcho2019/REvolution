module TopModule (
    input a,
    input b,
    output out
);
    // Equivalent implementation using primitive gates
    // Will synthesize to same result as a ~| b
    wire or_out;
    assign or_out = a | b;
    assign out = ~or_out;
endmodule