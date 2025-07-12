module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    assign out = a | (~b & c);
endmodule