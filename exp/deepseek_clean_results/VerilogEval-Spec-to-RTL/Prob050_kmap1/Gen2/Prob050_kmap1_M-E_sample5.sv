module TopModule(
    input a,
    input b,
    input c,
    output out
);
    wire nor_out;
    
    assign nor_out = ~(a | b | c);
    assign out = ~nor_out;
endmodule