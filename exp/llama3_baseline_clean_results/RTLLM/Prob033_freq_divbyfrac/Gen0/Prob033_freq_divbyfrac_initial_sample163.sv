module freq_divbyfrac (
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7;  // Clock cycles for 3.5x division
reg [2:0] counter;  // Counter for clock cycles

reg clk_div_ph0;  // Intermediate clock phase 0
reg clk_div_ph1;  // Intermediate clock phase 1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        counter <= 0;
        clk_div_ph0 <= 0;
        clk_div_ph1 <= 0;
    end else begin
        if (counter == 0) begin  // Start of new cycle
            clk_div_ph0 <= 1;  // Generate phase 0 clock
        end else if (counter == 3) begin  // End of phase 0 clock
            clk_div_ph0 <= 0;
        end

        if (counter == 4) begin  // Start of phase 1 clock
            clk_div_ph1 <= 1;
        end else if (counter == 6) begin  // End of phase 1 clock
            clk_div_ph1 <= 0;
        end

        if (counter == MUL2_DIV_CLK - 1) begin  // End of cycle
            counter <= 0;
        end else begin
            counter <= counter + 1;  // Increment counter
        end
    end
end

assign clk_div = clk_div_ph0 | clk_div_ph1;  // Generate final fractional divided clock

endmodule