module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out = 1'b0, and_out = 1'b0, or_out = 1'b0;

// Sequential logic (D flip-flops)
always @(posedge clk) begin
    xor_out <= x ^ xor_out;
    and_out <= x & ~and_out;
    or_out <= x | ~or_out;
end

// Combinational logic (gates and NOR gate)
assign z = ~(xor_out | and_out | or_out);

endmodule