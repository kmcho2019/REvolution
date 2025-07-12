module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk or negedge clk)
begin
    // not synthesizable, but this is what we're trying to replicate
    // q_reg <= d;
end

// approach 1: using two flip-flops
// reg q_pos, q_neg;
// always @(posedge clk) q_pos <= d;
// always @(negedge clk) q_neg <= d;
// assign q = q_pos | q_neg;

// approach 2: using a single flip-flop with XOR clock
reg clk_xor;
assign clk_xor = clk ^ ~clk;
always @(posedge clk_xor)
begin
    q_reg <= d;
end

endmodule