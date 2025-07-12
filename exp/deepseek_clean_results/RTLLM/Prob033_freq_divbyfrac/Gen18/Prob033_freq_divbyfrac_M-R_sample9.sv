module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_0;
reg phase_180;

// Main counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        counter <= (counter == 3'd6) ? 0 : counter + 1;
    end
end

// Phase generation (combinational)
always @(*) begin
    // Phase 0: active for first 4 cycles (0-3)
    phase_0 = (counter < 3'd4);

    // Phase 180: active for last 3 cycles (3-5)
    // Offset by 180 degrees (half period)
    phase_180 = (counter >= 3'd3) && (counter < 3'd6);
end

// Final output combines both phases
assign clk_div = phase_0 | phase_180;

endmodule