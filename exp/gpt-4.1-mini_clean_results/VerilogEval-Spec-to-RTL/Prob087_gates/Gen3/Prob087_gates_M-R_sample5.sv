module TopModule(
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

wire and_res, or_res, xor_res;

assign and_res = a & b;
assign or_res  = a | b;
assign xor_res = a ^ b;

always @(*) begin
    out_and   = and_res;
    out_or    = or_res;
    out_xor   = xor_res;
    out_nand  = ~and_res;
    out_nor   = ~or_res;
    out_xnor  = ~xor_res;
    out_anotb = a & ~b;
end

endmodule