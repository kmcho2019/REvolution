module TopModule (
    input  wire a,
    input  wire b,
    output reg  out_and,
    output reg  out_or,
    output reg  out_xor,
    output reg  out_nand,
    output reg  out_nor,
    output reg  out_xnor,
    output reg  out_anotb
);

    always @(*) begin
        out_and  = a & b;        // AND
        out_or   = a | b;        // OR
        out_xor  = a ^ b;        // XOR
        out_nand = ~(a & b);     // NAND
        out_nor  = ~(a | b);     // NOR
        out_xnor = ~(a ^ b);     // XNOR
        out_anotb= a & ~b;       // AND NOT (a and not b)
    end

endmodule