module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] diff;
    assign diff = A ^ B;       // Bitwise XOR - 0 where bits match
    assign z = ~|diff;         // NOR reduction - 1 only if all bits are 0

endmodule