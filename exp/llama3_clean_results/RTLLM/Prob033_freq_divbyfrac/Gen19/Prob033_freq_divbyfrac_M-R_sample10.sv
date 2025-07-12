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
reg [2:0] cnt;  // Counter for divided clock cycle
reg clk_int;  // Intermediate divided clock signal
reg clk_div_shift;  // Phase-shifted version of the divided clock signal
reg prev_clk;  // Previous clock signal for edge detection
reg half_clk;  // Half clock period signal

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int <= 1'b0;
        clk_div_shift <= 1'b0;
        clk_div <= 1'b0;
        prev_clk <= 1'b0;
        half_clk <= 1'b0;
    end else begin
        // Generate half clock period signal
        if (prev_clk == 1'b0 && clk == 1'b1) begin
            half_clk <= 1'b1;
        end else if (prev_clk == 1'b1 && clk == 1'b0) begin
            half_clk <= 1'b0;
        end
        // Update counter
        if (cnt == DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        // Generate intermediate divided clock signal
        if (cnt < DIV_CLK_LONG) begin
            clk_int <= 1'b1;
        end else begin
            clk_int <= 1'b0;
        end
        // Phase-shift the divided clock signal
        if (half_clk) begin
            clk_div_shift <= ~clk_int;
        end else begin
            clk_div_shift <= clk_int;
        end
        // Assign the final divided clock output
        clk_div <= (clk_int || clk_div_shift);
        prev_clk <= clk;
    end
end

endmodule