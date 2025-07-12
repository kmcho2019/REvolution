module TopModule(
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    wire [1:0] xor_ab;
    assign xor_ab = A ^ B;
    assign z = ~|xor_ab;  // Reduction NOR: 1 if all bits of xor_ab are 0, meaning A == B
endmodule