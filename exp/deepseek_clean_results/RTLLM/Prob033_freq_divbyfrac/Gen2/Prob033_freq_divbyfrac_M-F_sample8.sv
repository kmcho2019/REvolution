module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg clk_phase0;
reg clk_phase180;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else begin
        counter <= (counter == 3'b110) ? 3'b000 : counter + 1;
    end
end

// Phase 0 clock generation (toggles every 3 or 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase0 <= 1'b0;
    end else if (counter == 3'b000 || counter == 3'b100) begin
        clk_phase0 <= ~clk_phase0;
    end
end

// Phase 180 clock generation (same as phase0 but delayed by half cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase180 <= 1'b0;
    end else begin
        clk_phase180 <= clk_phase0;
    end
end

// Final output clock (OR of both phases)
assign clk_div = clk_phase0 | clk_phase180;

endmodule