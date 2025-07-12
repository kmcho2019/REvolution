module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // XOR-based equality check
    wire [1:0] diff;
    assign diff = A ^ B;          // Bitwise XOR
    assign z = ~|diff;            // NOR reduction (z=1 when all bits are 0)

endmodule