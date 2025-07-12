module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Behavioral equality comparison - lets synthesis tool choose optimal implementation
    assign z = (A == B);

endmodule