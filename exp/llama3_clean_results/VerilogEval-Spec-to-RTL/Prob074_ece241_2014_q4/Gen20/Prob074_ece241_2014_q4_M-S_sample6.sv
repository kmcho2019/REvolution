// Define the top-level module
module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out, and_out, or_out;

// Sequential logic to update the D flip-flops
always @(posedge clk) begin
    xor_out <= x ^ xor_out;
    and_out <= x & ~and_out;
    or_out <= x | ~or_out;
end

// Combinational logic to compute the output 'z'
assign z = ~(~xor_out | ~and_out | ~or_out);

endmodule