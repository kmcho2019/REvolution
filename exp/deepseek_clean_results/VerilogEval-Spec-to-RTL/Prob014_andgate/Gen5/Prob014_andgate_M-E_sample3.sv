module TopModule(
    input a,
    input b,
    output out
);
    // Implement AND gate using 2:1 MUX
    assign out = a ? b : 1'b0;
endmodule