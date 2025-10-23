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

    // Internal intermediate wires
    wire and_ab = a & b;
    wire or_ab  = a | b;
    wire xor_ab = a ^ b;

    always @(*) begin
        out_and  = and_ab;
        out_or   = or_ab;
        out_xor  = xor_ab;
        out_nand = ~and_ab;
        out_nor  = ~or_ab;
        out_xnor = ~xor_ab;
        out_anotb= a & (~b);
    end

endmodule