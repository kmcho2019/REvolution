module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg base_clk, phase_shift_clk;

// Simple 7-state counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1;
    end
end

// Base clock (high for 4 cycles, low for 3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        base_clk <= 1'b0;
    end else begin
        base_clk <= (counter < 3'd4);
    end
end

// Phase-shifted clock (delayed by half cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_shift_clk <= 1'b0;
    end else begin
        phase_shift_clk <= (counter < 3'd4);
    end
end

// Combined output
assign clk_div = base_clk | phase_shift_clk;

endmodule