module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bitwise equality using XNOR and creative reduction
    wire [1:0] bit_eq = ~(A ^ B);  // XNOR - each bit is 1 if equal
    wire any_neq = |(~bit_eq);     // OR of inverted equality bits
    assign z = ~any_neq;           // NOR gives 1 only if all bits equal
endmodule