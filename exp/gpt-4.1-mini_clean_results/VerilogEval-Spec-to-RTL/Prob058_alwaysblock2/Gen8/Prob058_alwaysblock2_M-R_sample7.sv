module TopModule (
    input        clk,
    input        a,
    input        b,
    output reg   out_always_comb,
    output       out_assign,
    output reg   out_always_ff
);

wire xor_val = a ^ b;

assign out_assign = xor_val;

always @(*) begin
    out_always_comb = xor_val;
end

always @(posedge clk) begin
    out_always_ff <= xor_val;
end

endmodule