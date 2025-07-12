module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter_p;  // Primary phase counter
reg [2:0] counter_n;  // Secondary phase counter (phase shifted)
reg primary_phase;
reg secondary_phase;

// Primary phase counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_p <= 3'b0;
        primary_phase <= 1'b0;
    end else begin
        counter_p <= (counter_p == 3'd6) ? 3'b0 : counter_p + 1'b1;
        primary_phase <= (counter_p <= 3'd3) ? 1'b1 : 1'b0;
    end
end

// Secondary phase counter (starts at midpoint for phase shift)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_n <= 3'd3;  // Start at midpoint for phase shift
        secondary_phase <= 1'b0;
    end else begin
        counter_n <= (counter_n == 3'd6) ? 3'b0 : counter_n + 1'b1;
        secondary_phase <= (counter_n >= 3'd4 || counter_n == 3'd0) ? 1'b1 : 1'b0;
    end
end

// Combine phases for final output
assign clk_div = primary_phase | secondary_phase;

endmodule