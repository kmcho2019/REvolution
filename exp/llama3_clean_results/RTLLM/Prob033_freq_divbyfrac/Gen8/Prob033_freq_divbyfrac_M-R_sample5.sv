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
reg prev_clk_div_int;  // Previous value of clk_div_int for delay

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        prev_clk_div_int <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        if (cnt == 3 || cnt == 6) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
        prev_clk_div_int <= clk_div_int;
    end
end

// Combinational logic for delayed signal
assign clk_div_delayed = (cnt == 4 || cnt == 7) ? 1'b1 : 1'b0;

// Combinational logic for final fractional divided clock output
assign clk_div = clk_div_int || clk_div_delayed;

endmodule