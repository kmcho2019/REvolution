module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// PLL clock signal
reg pll_clk;

// Counter register
reg [3:0] cnt;

// PLL: Divide the input clock by 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the PLL clock signal on reset
        pll_clk <= 0;
    end else begin
        // Toggle the PLL clock signal on each positive edge of the input clock
        pll_clk <= ~pll_clk;
    end
end

// Counter: Increment on each positive edge of the PLL clock signal
always @(posedge pll_clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock output on reset
        cnt <= 0;
        clk_div <= 0;
    end else begin
        // Increment the counter on each positive edge of the PLL clock signal
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
        end else begin
            // Toggle the divided clock output and reset the counter
            clk_div <= ~clk_div;
            cnt <= 0;
        end
    end
end

endmodule