module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter_p;  // Primary phase counter (posedge)
reg [2:0] counter_n;  // Secondary phase counter (negedge)
reg primary_phase;
reg secondary_phase;

// Primary phase counter (posedge triggered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_p <= 3'b0;
    end else begin
        counter_p <= (counter_p == 3'd6) ? 3'b0 : counter_p + 1'b1;
    end
end

// Secondary phase counter (negedge triggered, runs half-cycle ahead)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_n <= 3'b0;
    end else begin
        counter_n <= (counter_n == 3'd6) ? 3'b0 : counter_n + 1'b1;
    end
end

// Primary phase generation (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        primary_phase <= 1'b0;
    end else begin
        primary_phase <= (counter_p <= 3'd3) ? 1'b1 : 1'b0;
    end
end

// Secondary phase generation (3 high, 4 low)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        secondary_phase <= 1'b0;
    end else begin
        secondary_phase <= (counter_n <= 3'd2) ? 1'b1 : 1'b0;
    end
end

// Combine phases for final output
assign clk_div = primary_phase | secondary_phase;

endmodule