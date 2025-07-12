module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire eq0, eq1;
    
    assign eq0 = A[0] ~^ B[0];  // XNOR for bit 0 equality
    assign eq1 = A[1] ~^ B[1];  // XNOR for bit 1 equality
    assign z = eq0 & eq1;       // AND to verify all bits equal

endmodule