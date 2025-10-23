module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire pattern = a ^ b ^ c;
    assign out = d ? ~pattern : pattern;
endmodule