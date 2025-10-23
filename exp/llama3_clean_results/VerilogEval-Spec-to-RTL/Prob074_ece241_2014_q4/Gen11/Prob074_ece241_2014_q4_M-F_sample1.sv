module DFF(
    input clk,
    input rst_n, // Active low reset
    input d,
    output reg q = 1'b0 // Initialize q to 0
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 1'b0; // Reset to 0 on active low reset
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out; // Declare as wires instead of regs
wire xor_d, and_d, or_d;

DFF xor_ff(clk, 1'b1, xor_d, xor_out);
DFF and_ff(clk, 1'b1, and_d, and_out);
DFF or_ff(clk, 1'b1, or_d, or_out);

assign xor_d = x ^ xor_out;
assign and_d = x & ~and_out;
assign or_d = x | ~or_out;

// Use a simpler gate structure at the output
assign z = ~(xor_out | and_out | or_out);

endmodule