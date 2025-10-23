module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] diff;
    
    assign diff = A ^ B;      // XOR each bit pair (0 when bits match)
    assign z = ~|diff;        // NOR reduction (1 when all bits are 0)

endmodule