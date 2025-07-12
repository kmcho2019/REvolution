module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Direct combinational logic implementation
    assign out = a | (~b & c);
endmodule