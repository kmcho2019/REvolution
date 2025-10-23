module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles

reg [2:0] counter; // Counter to generate uneven clock periods
reg div_clk;      // Intermediate divided clock signal
reg div_clk_delayed; // Phase-shifted version of div_clk (delayed by half a clock period)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0; // Initialize counter to 0
        div_clk <= 1'b0; // Initialize div_clk to 0
        div_clk_delayed <= 1'b0; // Initialize div_clk_delayed to 0
        clk_div <= 1'b0; // Initialize clk_div to 0
    end else begin
        counter <= (counter == MUL2_DIV_CLK - 1) ? 3'd0 : counter + 1; // Increment counter and reset when reaches MUL2_DIV_CLK

        // Toggle div_clk at specific counter values
        if (counter == 3'd3) begin
            div_clk <= ~div_clk; // Toggle div_clk
        end

        // Generate phase-shifted version of div_clk
        div_clk_delayed <= (counter == 3'd0) ? div_clk : div_clk_delayed; // Delay div_clk by half a clock period

        // Generate final fractional divided clock output
        clk_div <= (div_clk && (counter < 3'd4)) || (div_clk_delayed && (counter >= 3'd4)); // Logically OR the phase-shifted versions of div_clk
    end
end

endmodule