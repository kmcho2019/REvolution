module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Direct behavioral assign for XOR
assign out_assign = a ^ b;

always @(*) begin
    if (a == 1'b0) begin
        if (b == 1'b0) out_always_comb = 1'b0;
        else           out_always_comb = 1'b1;
    end else begin
        if (b == 1'b0) out_always_comb = 1'b1;
        else           out_always_comb = 1'b0;
    end
end

reg xor_comb_reg;

always @(*) begin
    xor_comb_reg = a ^ b;  // combinational XOR for sequential path
end

always @(posedge clk) begin
    out_always_ff <= xor_comb_reg; // registered output delayed by one clk cycle
end

endmodule