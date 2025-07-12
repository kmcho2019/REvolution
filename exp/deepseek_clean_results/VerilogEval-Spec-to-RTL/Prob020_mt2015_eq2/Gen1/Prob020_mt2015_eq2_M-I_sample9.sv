module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Compare bits using XNOR gates directly
    assign z = (A[0] ~^ B[0]) & (A[1] ~^ B[1]);

endmodule