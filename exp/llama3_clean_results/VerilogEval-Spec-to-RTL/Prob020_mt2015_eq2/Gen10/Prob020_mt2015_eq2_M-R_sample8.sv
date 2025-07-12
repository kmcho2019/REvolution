module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);
    assign z = (A[1] == B[1]) && (A[0] == B[0]);
endmodule