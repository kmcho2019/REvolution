module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire select = a | b;
    assign out = select ? 1'b1 : c;
endmodule