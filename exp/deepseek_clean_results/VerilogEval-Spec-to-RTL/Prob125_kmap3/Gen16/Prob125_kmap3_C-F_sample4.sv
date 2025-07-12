module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized single assignment combining both approaches
    // Logic equivalent to: a OR (NOT b AND c)
    assign out = a | (~b & c);
endmodule