module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;

// Initialize flip-flops
initial begin
    xor_ff_out = 0;
    and_ff_out = 0;
    or_ff_out = 0;
end

// Instantiate D flip-flops
always @(posedge clk) begin
    xor_ff_out <= x ^ xor_ff_out;
    and_ff_out <= x && ~and_ff_out;
    or_ff_out <= x || ~or_ff_out;
end

// Generate output z
assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

endmodule