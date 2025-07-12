module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles

reg [2:0] counter; // Counter to generate uneven clock periods
reg div_clk;      // Intermediate divided clock signal
reg div_clk_delayed; // Phase-shifted version of div_clk (delayed by half a clock period)
reg div_clk_advanced; // Phase-shifted version of div_clk (advanced by half a clock period)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0; // Initialize counter to 0
        div_clk <= 1'b0; // Initialize div_clk to 0
        div_clk_delayed <= 1'b0; // Initialize div_clk_delayed to 0
        div_clk_advanced <= 1'b0; // Initialize div_clk_advanced to 0
        clk_div <= 1'b0; // Initialize clk_div to 0
    end else begin
        counter <= (counter == MUL2_DIV_CLK - 1) ? 3'd0 : counter + 1; // Increment counter and reset when reaches MUL2_DIV_CLK

        if (counter == 3'd3 || counter == MUL2_DIV_CLK - 1) begin // Toggle div_clk at specific counter values
            div_clk <= ~div_clk; // Toggle div_clk
        end

        // Generate phase-shifted versions of div_clk
        if (~rst_n) begin
            div_clk_delayed <= 1'b0; // Reset div_clk_delayed on reset
            div_clk_advanced <= 1'b0; // Reset div_clk_advanced on reset
        end else if (counter == 3'd0) begin // Set div_clk_delayed and div_clk_advanced based on div_clk at specific counter value
            div_clk_delayed <= div_clk; 
            div_clk_advanced <= ~div_clk; 
        end else begin // Otherwise, hold previous values of div_clk_delayed and div_clk_advanced
            div_clk_delayed <= div_clk_delayed;
            div_clk_advanced <= div_clk_advanced;
        end

        // Generate final fractional divided clock output
        clk_div <= div_clk_delayed | div_clk_advanced; // Logically OR the phase-shifted versions of div_clk
    end
end

endmodule