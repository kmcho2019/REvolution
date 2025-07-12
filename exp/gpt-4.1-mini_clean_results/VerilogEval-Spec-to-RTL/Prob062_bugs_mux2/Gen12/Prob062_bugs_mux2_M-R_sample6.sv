module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Select input vector based on sel
    wire [7:0] selected = sel ? b : a;

    // Reduce selected vector to a single bit by OR'ing all bits
    assign out = |selected;

endmodule