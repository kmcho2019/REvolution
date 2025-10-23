module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Most concise and optimal NOR implementation
endmodule