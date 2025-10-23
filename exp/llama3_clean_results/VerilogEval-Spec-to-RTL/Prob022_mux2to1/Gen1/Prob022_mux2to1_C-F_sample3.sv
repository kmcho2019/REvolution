module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

    // Using a concise conditional operator for simplicity and efficiency
    assign out = sel ? b : a;

endmodule