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
reg [2:0] cnt;  // Counter for clock cycles
reg clk_int;  // Intermediate divided clock signal
reg clk_div_int;  // Intermediate divided clock output before phase-shifting
reg clk_div_shift;  // Phase-shifted version of the divided clock signal

// Sequential logic for counter and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int <= 1'b0;
        clk_div_int <= 1'b0;
        clk_div_shift <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < DIV_CLK_LONG - 1) begin
            cnt <= cnt + 1'b1;
            clk_int <= 1'b1;
        end else if (cnt < DIV_CLK - 1) begin
            cnt <= cnt + 1'b1;
            clk_int <= 1'b0;
        end else begin
            cnt <= 3'b000;
            clk_int <= 1'b0;
        end
        // Generate intermediate divided clock output before phase-shifting
        if (cnt == DIV_CLK_LONG - 1 || cnt == DIV_CLK - 1) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
        // Phase-shift the divided clock signal
        if (cnt == DIV_CLK_LONG - 1) begin
            clk_div_shift <= 1'b1;
        end else if (cnt == DIV_CLK - 1) begin
            clk_div_shift <= 1'b0;
        end else begin
            clk_div_shift <= 1'b0;
        end
        // Assign the final divided clock output
        clk_div <= (clk_div_int || clk_div_shift);
    end
end

endmodule