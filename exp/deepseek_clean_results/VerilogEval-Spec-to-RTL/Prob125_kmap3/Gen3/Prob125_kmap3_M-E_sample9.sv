module TopModule(
    input a,
    input b,
    input c,
    input d,  // unused as don't-care
    output out
);
    assign out = c ? (a | b) : (a ^ b);
endmodule