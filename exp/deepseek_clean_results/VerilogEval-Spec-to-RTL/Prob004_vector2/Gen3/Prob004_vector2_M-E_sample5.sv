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
    wire [7:0] stage1_0, stage1_1, stage1_2, stage1_3;
    wire [7:0] stage2_0, stage2_1, stage2_2, stage2_3;
    
    // First stage: Swap adjacent bytes
    ByteSwapper #(8) swap0(.byteA(in[31:24]), .byteB(in[23:16]), 
                         .swappedA(stage1_0), .swappedB(stage1_1));
    ByteSwapper #(8) swap1(.byteA(in[15:8]), .byteB(in[7:0]), 
                         .swappedA(stage1_2), .swappedB(stage1_3));
    
    // Second stage: Swap the swapped pairs
    ByteSwapper #(8) swap2(.byteA(stage1_0), .byteB(stage1_2), 
                         .swappedA(stage2_0), .swappedB(stage2_2));
    ByteSwapper #(8) swap3(.byteA(stage1_1), .byteB(stage1_3), 
                         .swappedA(stage2_1), .swappedB(stage2_3));
    
    // Final output
    assign out = {stage2_0, stage2_1, stage2_2, stage2_3};
endmodule