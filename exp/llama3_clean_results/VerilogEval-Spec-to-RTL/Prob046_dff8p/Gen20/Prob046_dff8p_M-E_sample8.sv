module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg reset_pulse;

// Generate a single-clock-cycle pulse when the reset signal is asserted
always @(posedge clk) begin
    if (reset) begin
        reset_pulse <= 1'b1;
    end else begin
        reset_pulse <= 1'b0;
    end
end

// Update the D flip-flop on the negative edge of the clock
always @(negedge clk) begin
    if (reset_pulse) begin
        q_reg <= 8'h34; // Reset value
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule