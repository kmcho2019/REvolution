module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused but kept for interface compatibility
    output out
);
    assign out = a | (~b & c);
endmodule