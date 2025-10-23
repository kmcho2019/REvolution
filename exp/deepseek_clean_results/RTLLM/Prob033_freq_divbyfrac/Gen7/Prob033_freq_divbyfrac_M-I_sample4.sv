module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] cnt_primary;  // Primary phase counter (0-6)
reg [2:0] cnt_secondary; // Secondary phase counter (0-6)
wire primary_high;
wire secondary_high;

// Primary phase counter (posedge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_primary <= 3'b0;
    end else begin
        cnt_primary <= (cnt_primary == 3'd6) ? 3'b0 : cnt_primary + 1'b1;
    end
end

// Secondary phase counter (negedge, starts at 3 for phase shift)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_secondary <= 3'd3; // Start at midpoint for 180° shift
    end else begin
        cnt_secondary <= (cnt_secondary == 3'd6) ? 3'b0 : cnt_secondary + 1'b1;
    end
end

// Phase generation (combinational)
assign primary_high = (cnt_primary <= 3'd3);  // High for 4 cycles
assign secondary_high = (cnt_secondary <= 3'd2); // High for 3 cycles

// Registered output to prevent glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= primary_high | secondary_high;
    end
end

endmodule