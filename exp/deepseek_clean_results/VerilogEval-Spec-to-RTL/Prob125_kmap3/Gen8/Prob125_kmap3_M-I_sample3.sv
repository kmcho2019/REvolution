module TopModule(
    input a,
    input b,
    input c,
    input d,  // Don't-care input
    output out
);
    // Implementation of K-map:
    // out = a OR (NOT b AND c)
    // d is don't-care and not used
    wire out_wire = a | (~b & c);
    assign out = out_wire;
endmodule