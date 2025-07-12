module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Primary implementation: direct concatenation (optimal PPA)
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
    
    /* Alternative modular implementation (commented out but available)
    module ByteSwapper #(parameter WIDTH = 8) (
        input  [WIDTH-1:0] byteA, byteB,
        output [WIDTH-1:0] swappedA, swappedB
    );
        assign swappedA = byteB;
        assign swappedB = byteA;
    endmodule
    
    wire [7:0] b0, b1, b2, b3;
    ByteSwapper #(8) s0(.byteA(in[31:24]), .byteB(in[7:0]), .swappedA(b0), .swappedB(b3));
    ByteSwapper #(8) s1(.byteA(in[23:16]), .byteB(in[15:8]), .swappedA(b1), .swappedB(b2));
    assign out = {b0, b1, b2, b3};
    */
endmodule