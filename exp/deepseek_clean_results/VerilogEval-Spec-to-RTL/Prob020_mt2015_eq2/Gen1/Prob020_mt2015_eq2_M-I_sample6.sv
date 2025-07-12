module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Direct comparison using XNOR gates (A ~^ B) or equality operator
    assign z = (A == B);

endmodule