module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for clock generators
reg clk_ref;  // Reference divided clock
reg clk_delayed;  // Delayed version of clk_ref
reg clk_advanced;  // Advanced version of clk_ref

// Clock cycle counter and phase controller
reg [2:0] counter;
reg [2:0] next_counter;

// Control signals for clock generators
reg gen_delayed;  // Enable signal for delayed clock generator
reg gen_advanced;  // Enable signal for advanced clock generator

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        counter <= 3'd0;
        clk_ref <= 1'b0;
        clk_delayed <= 1'b0;
        clk_advanced <= 1'b0;
        gen_delayed <= 1'b0;
        gen_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Count clock cycles
        if (counter == 3'd3) begin
            counter <= 3'd0;
            clk_ref <= ~clk_ref;  // Toggle reference clock
        end else begin
            counter <= counter + 1;
        end

        // Generate phase-shifted clocks
        if (counter == 3'd1 || counter == 3'd4) begin
            // Toggle delayed and advanced clocks
            clk_delayed <= ~clk_delayed;
            clk_advanced <= ~clk_advanced;
        end

        // Assign output
        if (counter < 3'd4) begin
            // Use delayed clock for first 4 cycles
            clk_div <= clk_delayed;
        end else begin
            // Use advanced clock for last 3 cycles
            clk_div <= clk_advanced;
        end
    end
end

endmodule