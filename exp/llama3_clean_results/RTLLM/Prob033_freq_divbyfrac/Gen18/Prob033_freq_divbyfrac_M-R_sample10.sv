module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Internal signals
reg [2:0] cnt;  // Counter

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Combinatorial logic to generate divided clock signals
assign clk_div = (cnt < DIV_CLK_LONG) || (cnt >= DIV_CLK_LONG && cnt < DIV_CLK_LONG + 1);

endmodule