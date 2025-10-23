module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire [1:0] diff;
    
    // Bitwise XOR comparison
    assign diff[1] = A[1] ^ B[1];
    assign diff[0] = A[0] ^ B[0];
    
    // NOR-based equality detection
    assign z = ~(diff[1] | diff[0]);
endmodule