module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg base_clk, phase_shift_clk;

// 7-state counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1;
    end
end

// Base clock generation
// High for cycles 0-3 (4 cycles), low for 4-6 (3 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        base_clk <= 1'b0;
    end else begin
        base_clk <= (counter < 3'd4);
    end
end

// True phase-shifted clock (half-cycle delayed)
// Sampled at negedge to create proper phase shift
reg [2:0] counter_delayed;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_delayed <= 3'b0;
        phase_shift_clk <= 1'b0;
    end else begin
        counter_delayed <= counter;
        phase_shift_clk <= (counter_delayed < 3'd4);
    end
end

// Combined output
assign clk_div = base_clk | phase_shift_clk;

endmodule