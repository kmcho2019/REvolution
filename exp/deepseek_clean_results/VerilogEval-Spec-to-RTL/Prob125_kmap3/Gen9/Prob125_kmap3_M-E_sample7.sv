module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    assign out = a ? 1'b1 : (~b & c);
endmodule