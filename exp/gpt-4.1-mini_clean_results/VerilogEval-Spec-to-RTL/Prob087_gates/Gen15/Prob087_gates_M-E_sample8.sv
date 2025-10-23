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
        out_and  = a & b;
        out_or   = a | b;
        out_xor  = a ^ b;
        out_nand = ~(a & b);
        out_nor  = ~(a | b);
        out_xnor = ~(a ^ b);
        out_anotb= a & (~b);
    end

endmodule