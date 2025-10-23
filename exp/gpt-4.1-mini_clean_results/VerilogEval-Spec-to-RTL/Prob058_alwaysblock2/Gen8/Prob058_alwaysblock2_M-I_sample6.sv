module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

assign out_assign = a ^ b;

always @(*) begin
    out_always_comb = a ^ b;
end

reg xor_prev;
wire xor_curr = a ^ b;

always @(posedge clk) begin
    if (xor_curr != xor_prev) begin
        out_always_ff <= xor_curr;
    end
    xor_prev <= xor_curr;
end

endmodule