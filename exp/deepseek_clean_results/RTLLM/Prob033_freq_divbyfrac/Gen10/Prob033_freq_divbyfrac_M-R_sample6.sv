module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_cnt;
wire main_clk;
wire shift_clk;

// 7-cycle counter (0-6) for 3.5x division
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_cnt <= 3'b0;
    end else begin
        cycle_cnt <= (cycle_cnt == 3'd6) ? 3'b0 : cycle_cnt + 1;
    end
end

// Main clock (4 cycles high, 3 cycles low)
assign main_clk = (cycle_cnt < 3'd4) ? 1'b1 : 1'b0;

// Phase-shifted clock (negative edge triggered)
reg [2:0] cycle_cnt_delayed;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_cnt_delayed <= 3'b0;
    end else begin
        cycle_cnt_delayed <= cycle_cnt;
    end
end

assign shift_clk = (cycle_cnt_delayed < 3'd4) ? 1'b1 : 1'b0;

// Combined output for fractional division
assign clk_div = main_clk | shift_clk;

endmodule