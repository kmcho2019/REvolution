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
reg clk_int1;  // Intermediate divided clock signal 1 (longer part)
reg clk_int2;  // Intermediate divided clock signal 2 (shorter part)

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < DIV_CLK_LONG - 1) begin
            cnt <= cnt + 1'b1;
            clk_int1 <= 1'b1;
            clk_int2 <= 1'b0;
        end else if (cnt < DIV_CLK_LONG + DIV_CLK_SHORT - 1) begin
            cnt <= cnt + 1'b1;
            clk_int1 <= 1'b0;
            clk_int2 <= 1'b1;
        end else begin
            cnt <= 3'b000;
            clk_int1 <= 1'b0;
            clk_int2 <= 1'b0;
        end
        // Assign the final divided clock output
        clk_div <= (clk_int1 || clk_int2);
    end
end

endmodule