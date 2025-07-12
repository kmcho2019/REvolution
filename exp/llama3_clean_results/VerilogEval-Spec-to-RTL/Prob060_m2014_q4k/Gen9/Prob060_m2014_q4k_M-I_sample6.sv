module TopModule(
    input clk,
    input resetn,
    input in,
    input enable,
    output out
);

reg [3:0] shift_register;
reg clk_gated;

always @(posedge clk) begin
    if (!resetn) begin
        shift_register <= 4'b0000;
    end else if (enable) begin
        shift_register <= {in, shift_register[3:1]};
    end
end

assign out = shift_register[0];

// Note: The following clock gating logic is for illustration purposes.
// In practice, this might be handled differently based on the specific
// technology and synthesis tool being used.
assign clk_gated = clk & enable;

// The above clock_gated signal is not actually used in this example
// since we've integrated the enable logic directly into the always block.
// In a real implementation, you might use clk_gated instead of clk for
// the always block if your technology supports clock gating in this manner.

endmodule