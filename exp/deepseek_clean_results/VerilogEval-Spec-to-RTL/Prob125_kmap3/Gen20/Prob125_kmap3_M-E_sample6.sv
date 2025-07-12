module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Implement as a 2:1 mux where:
    // - When a=1: output is 1
    // - When a=0: output is (~b & c)
    assign out = a ? 1'b1 : (~b & c);
endmodule