module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Output is 1 when A equals B, 0 otherwise
    assign z = (A == B);

endmodule