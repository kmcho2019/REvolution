module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;  // 0-6 counter for 3.5x division
reg primary_phase;
reg secondary_phase;

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

// Secondary phase generation (half-cycle delayed version)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        secondary_phase <= 1'b0;
    end else begin
        // Shift comparison by 1 to create proper phase offset
        secondary_phase <= (counter <= 3'd2) ? 1'b1 : 1'b0;
    end
end

// Combine both phases to create final output
assign clk_div = primary_phase | secondary_phase;

endmodule