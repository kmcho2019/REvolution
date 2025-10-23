module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire nor_result;
    assign nor_result = ~(a | b | c);
    assign out = ~nor_result;
endmodule