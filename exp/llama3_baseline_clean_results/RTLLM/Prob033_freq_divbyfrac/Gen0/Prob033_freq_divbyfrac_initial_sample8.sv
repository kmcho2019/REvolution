module freq_divbyfrac(
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Parameters for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total cycles for division
parameter DIV_CYCLES_1 = 4; // First division cycle count
parameter DIV_CYCLES_2 = 3; // Second division cycle count

reg [2:0] counter; // Counter to cycle through division periods
reg div_clk_1, div_clk_2; // Intermediate divided clocks
reg div_clk_1_phase, div_clk_2_phase; // Phase-shifted intermediate clocks

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        div_clk_1 <= 1'b0;
        div_clk_2 <= 1'b0;
        div_clk_1_phase <= 1'b0;
        div_clk_2_phase <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Cycle through division periods
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate intermediate divided clocks based on cycle counts
        if (counter == DIV_CYCLES_1 - 1) begin
            div_clk_1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            div_clk_1 <= 1'b0;
        end
        
        if (counter == DIV_CYCLES_2 - 1) begin
            div_clk_2 <= 1'b1;
        end else if (counter == DIV_CYCLES_1 + DIV_CYCLES_2 - 1) begin
            div_clk_2 <= 1'b0;
        end
        
        // Phase-shifting intermediate clocks
        div_clk_1_phase <= div_clk_1;
        div_clk_2_phase <= div_clk_2;
        
        // Logical OR of phase-shifted clocks to produce final output
        // Note: This is a simplified model and may need adjustments based on actual implementation requirements
        //       for phase shifting and logical operations to achieve the desired fractional division.
        clk_div <= div_clk_1_phase | div_clk_2_phase;
    end
end

endmodule