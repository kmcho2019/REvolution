module TopModule (
    input clk,
    input d,
    output q
);

// Internal inverted clock
wire clk_inv;
assign clk_inv = ~clk;

// Storage elements for both clock phases
reg q_phase0, q_phase180;

// Capture data on original clock (0° phase)
always @(posedge clk) begin
    q_phase0 <= d;
end

// Capture data on inverted clock (180° phase)
always @(posedge clk_inv) begin
    q_phase180 <= d;
end

// Combine both phases - functionally equivalent to dual-edge sampling
assign q = q_phase0 | q_phase180;

endmodule