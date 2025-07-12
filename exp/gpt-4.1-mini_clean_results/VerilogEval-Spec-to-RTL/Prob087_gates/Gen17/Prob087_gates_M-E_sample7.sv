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
        out_and  = a & b;       // AND gate
        out_or   = a | b;       // OR gate
        out_xor  = a ^ b;       // XOR gate
        out_nand = ~(a & b);    // NAND gate
        out_nor  = ~(a | b);    // NOR gate
        out_xnor = ~(a ^ b);    // XNOR gate
        out_anotb= a & (~b);    // AND NOT gate
    end

endmodule