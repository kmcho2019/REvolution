module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV1_CLK = 4;      // Clock cycles for first phase
parameter DIV2_CLK = 3;      // Clock cycles for second phase

// Internal signals
reg [2:0] cnt;  // Counter for 7 clock cycles
reg div_clk1, div_clk2;  // Divided clock signals for each phase
reg delayed_div_clk1, advanced_div_clk2;  // Phase-shifted clock signals

// Counter for 7 clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Generate divided clock signals for each phase
assign div_clk1 = (cnt == DIV1_CLK - 1);
assign div_clk2 = (cnt == MUL2_DIV_CLK - 1);

// Generate phase-shifted clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        delayed_div_clk1 <= 1'b0;
        advanced_div_clk2 <= 1'b0;
    end else begin
        delayed_div_clk1 <= div_clk1;
        advanced_div_clk2 <= div_clk2;
    end
end

// Generate final fractional divided clock output
assign clk_div = delayed_div_clk1 | advanced_div_clk2;

endmodule