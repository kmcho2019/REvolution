// Define a single 8-bit D flip-flop module with active high synchronous reset
module DFF_8bit(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34; // Reset value

reg [7:0] q_reg;

// Using clock gating for power reduction, though the current power is already low
reg clk_gated;
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

always @(negedge clk_gated) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule remains the same as it is already optimized for area
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the 8-bit DFF
DFF_8bit u_dff_8bit(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule