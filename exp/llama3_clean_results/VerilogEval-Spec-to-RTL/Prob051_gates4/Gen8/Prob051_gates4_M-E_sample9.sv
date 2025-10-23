// Define a binary tree node module that can perform AND, OR, or XOR
module BinaryTreenodeName(
    input  a,
    input  b,
    input  [1:0] op, // 0: AND, 1: OR, 2: XOR
    output out
);
    assign out = (op == 0) ? (a & b) : ((op == 1) ? (a | b) : (a ^ b));
endmodule

// Implement the 4-input AND gate using a binary tree
module FourInputANDBinaryTree(
    input  [3:0] in,
    output out
);
    wire and1, and2;
    BinaryTreenodeName andNode1(in[3], in[2], 2'b00, and1);
    BinaryTreenodeName andNode2(in[1], in[0], 2'b00, and2);
    BinaryTreenodeName andNode3(and1, and2, 2'b00, out);
endmodule

// Implement the 4-input OR gate using a binary tree
module FourInputORBinaryTree(
    input  [3:0] in,
    output out
);
    wire or1, or2;
    BinaryTreenodeName orNode1(in[3], in[2], 2'b01, or1);
    BinaryTreenodeName orNode2(in[1], in[0], 2'b01, or2);
    BinaryTreenodeName orNode3(or1, or2, 2'b01, out);
endmodule

// Implement the 4-input XOR gate using a binary tree
module FourInputXORBinaryTree(
    input  [3:0] in,
    output out
);
    wire xor1, xor2;
    BinaryTreenodeName xorNode1(in[3], in[2], 2'b10, xor1);
    BinaryTreenodeName xorNode2(in[1], in[0], 2'b10, xor2);
    BinaryTreenodeName xorNode3(xor1, xor2, 2'b10, out);
endmodule

// Top-level module instantiating the binary trees
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    FourInputANDBinaryTree andTree(in, out_and);
    FourInputORBinaryTree orTree(in, out_or);
    FourInputXORBinaryTree xorTree(in, out_xor);
endmodule