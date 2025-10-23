module TopModule(
    input a,
    input b,
    output out
);
    // Implement AND using a multiplexer
    assign out = a ? b : 1'b0;
endmodule