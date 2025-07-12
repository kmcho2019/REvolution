module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire bit_eq1, bit_eq0;

    assign bit_eq1 = ~(A[1] ^ B[1]);
    assign bit_eq0 = ~(A[0] ^ B[0]);
    assign z = bit_eq1 & bit_eq0;
endmodule