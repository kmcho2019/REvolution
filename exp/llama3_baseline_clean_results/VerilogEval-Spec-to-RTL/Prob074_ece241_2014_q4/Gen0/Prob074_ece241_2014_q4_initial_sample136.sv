module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_ff, and_ff, or_ff;

always @ (posedge clk) begin
    xor_ff <= x ^ xor_ff;
    and_ff <= x & (~and_ff);
    or_ff <= x | (~or_ff);
end

assign z = ~(xor_ff | and_ff | or_ff);

endmodule