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
        // shared intermediate signals
        out_and   = a & b;
        out_or    = a | b;
        out_xor   = a ^ b;

        out_nand  = ~out_and;      // reuse out_and
        out_nor   = ~out_or;       // reuse out_or
        out_xnor  = ~out_xor;      // reuse out_xor
        out_anotb = a & (~b);
    end

endmodule