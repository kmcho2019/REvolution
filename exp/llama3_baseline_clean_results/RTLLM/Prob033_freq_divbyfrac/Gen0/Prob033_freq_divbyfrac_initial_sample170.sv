module freq_divbyfrac (
    input  clk,
    input  rst_n,
    output clk_div
);

// Define the parameters for the fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLKCycle1 = 4; // Clock cycles for the first divided clock
parameter DIV_CLKCycle2 = 3; // Clock cycles for the second divided clock

// Counter to keep track of the clock cycles
reg [2:0] counter;
reg prev_clk;

// Intermediate divided clock signals
reg clk_div1;
reg clk_div2;

// Phase-shifted versions of the divided clock signals
reg clk_div1_delayed;
reg clk_div2_advanced;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter and intermediate clock signals
        counter <= 3'd0;
        prev_clk <= 1'b0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        clk_div1_delayed <= 1'b0;
        clk_div2_advanced <= 1'b0;
    end else begin
        // Increment the counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;
        end

        // Generate the intermediate divided clock signals
        if (counter < DIV_CLKCycle1) begin
            clk_div1 <= 1'b1;
        end else begin
            clk_div1 <= 1'b0;
        end

        if (counter >= DIV_CLKCycle1 && counter < MUL2_DIV_CLK) begin
            clk_div2 <= 1'b1;
        end else begin
            clk_div2 <= 1'b0;
        end

        // Use the double-edge clocking technique to generate phase-shifted versions of the divided clock signals
        if (prev_clk == 1'b0 && clk == 1'b1) begin
            // Rising edge of the clock
            clk_div1_delayed <= clk_div1;
            clk_div2_advanced <= clk_div2;
        end else if (prev_clk == 1'b1 && clk == 1'b0) begin
            // Falling edge of the clock
            clk_div1_delayed <= 1'b0;
            clk_div2_advanced <= 1'b0;
        end

        prev_clk <= clk;
    end
end

// Logically OR the two intermediate clocks to produce the final fractional divided clock output
assign clk_div = clk_div1_delayed | clk_div2_advanced;

endmodule