module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for counter
reg [2:0] counter;
reg [2:0] next_counter;

// Signals for phase-shifted clock
reg clk_div_dly;
reg clk_div_adv;

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            next_counter <= 3'd0;
        end else begin
            next_counter <= counter + 1;
        end
        counter <= next_counter;
    end
end

// Phase-shifted clock signals
assign clk_div_dly = (counter < 4) ? 1'b1 : 1'b0;
assign clk_div_adv = (counter >= 4 && counter < 7) ? 1'b1 : 1'b0;

// Clock output generator
assign clk_div = clk_div_dly || clk_div_adv;

endmodule