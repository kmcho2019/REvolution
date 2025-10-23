module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int;  // Intermediate divided clock
reg clk_div_delayed;  // Delayed intermediate divided clock
reg clk_div_adv;  // Advanced intermediate divided clock

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        if ((cnt >= 3'd0 && cnt <= 3'd3) || (cnt >= 3'd4 && cnt <= 3'd6)) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
    end
end

// Combinational logic for phase-shifting
assign clk_div_delayed = (cnt == 3'd0 || cnt == 3'd4) ? 1'b1 : 1'b0;
assign clk_div_adv = (cnt == 3'd1 || cnt == 3'd5) ? 1'b1 : 1'b0;

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int || clk_div_delayed || clk_div_adv;

endmodule