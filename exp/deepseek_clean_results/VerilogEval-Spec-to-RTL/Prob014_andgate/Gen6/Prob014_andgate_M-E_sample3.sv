module TopModule(
    input a,
    input b,
    output out
);
    // Implement AND using a 2:1 mux
    assign out = a ? b : 1'b0;
endmodule