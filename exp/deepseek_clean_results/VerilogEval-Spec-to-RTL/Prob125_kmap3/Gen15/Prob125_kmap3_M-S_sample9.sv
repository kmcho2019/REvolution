module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused but required by interface
    output out
);
    assign out = a | (~b & c);
endmodule