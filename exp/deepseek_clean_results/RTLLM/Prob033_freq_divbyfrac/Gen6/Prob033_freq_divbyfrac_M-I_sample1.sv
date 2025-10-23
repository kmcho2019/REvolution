module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;      // 0-6 counter for 3.5x division
reg primary_phase;
reg secondary_phase;
reg secondary_toggle;   // For precise half-cycle delay

// Main counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Primary phase generation (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        primary_phase <= 1'b0;
    end else begin
        primary_phase <= (counter <= 3'd3) ? 1'b1 : 1'b0;
    end
end

// Secondary phase control (toggles every 3.5 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        secondary_toggle <= 1'b0;
    end else if (counter == 3'd3) begin
        secondary_toggle <= ~secondary_toggle;
    end
end

// Secondary phase generation (half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        secondary_phase <= 1'b0;
    end else begin
        secondary_phase <= secondary_toggle;
    end
end

// Combine both phases to create final output
assign clk_div = primary_phase | secondary_phase;

endmodule