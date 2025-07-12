module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ((a == b) && (c != d)) || ((a != b) && (c == d)) ? 1'b1 : 1'b0;

endmodule