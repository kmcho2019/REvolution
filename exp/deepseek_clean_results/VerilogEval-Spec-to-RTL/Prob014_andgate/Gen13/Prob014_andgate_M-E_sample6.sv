module TopModule(
    input a,
    input b,
    output out
);
    // 2-input AND implemented using a multiplexer
    assign out = a ? b : 1'b0;
endmodule