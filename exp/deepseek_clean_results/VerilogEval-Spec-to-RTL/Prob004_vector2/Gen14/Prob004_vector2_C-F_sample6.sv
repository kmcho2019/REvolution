module ByteSwapper #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] byteA,
    input  [WIDTH-1:0] byteB,
    output [WIDTH-1:0] swappedA,
    output [WIDTH-1:0] swappedB
);
    assign swappedA = byteB;
    assign swappedB = byteA;
endmodule

module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Named byte segments for clarity
    wire [7:0] byte3 = in[31:24];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte1 = in[15:8]; 
    wire [7:0] byte0 = in[7:0];
    
    // Demonstrate modularity (though not strictly needed for this simple case)
    wire [7:0] swapped_byte3, swapped_byte0;
    ByteSwapper #(8) end_swap(.byteA(byte3), .byteB(byte0),
                            .swappedA(swapped_byte3), .swappedB(swapped_byte0));
    
    // Efficient direct concatenation for core functionality
    assign out = {swapped_byte0, byte1, byte2, swapped_byte3};
endmodule