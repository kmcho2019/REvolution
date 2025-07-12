module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for the frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for one full division period
parameter DIV_CLK_P1 = 4;    // Clock cycles for the first divided clock period
parameter DIV_CLK_P2 = 3;    // Clock cycles for the second divided clock period

reg [2:0] counter; // Counter to track the clock cycles
reg clk_int1, clk_int2; // Intermediate divided clock signals
reg clk_int1_shift, clk_int2_shift; // Phase-shifted versions of the intermediate clocks

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_shift <= 1'b0;
        clk_int2_shift <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate intermediate clocks based on the counter value
        if (counter == DIV_CLK_P1 - 1) begin
            clk_int1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b0;
        end
        
        if (counter == DIV_CLK_P2 - 1) begin
            clk_int2 <= 1'b1;
        end else if (counter == DIV_CLK_P1) begin
            clk_int2 <= 1'b0;
        end
        
        // Phase-shifting of the intermediate clocks
        if (counter == DIV_CLK_P1) begin
            clk_int1_shift <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1_shift <= 1'b0;
        end
        
        if (counter == DIV_CLK_P2) begin
            clk_int2_shift <= 1'b1;
        end else if (counter == DIV_CLK_P1 - 1) begin
            clk_int2_shift <= 1'b0;
        end
        
        // Final fractional clock output
        clk_div <= clk_int1 | clk_int2 | clk_int1_shift | clk_int2_shift;
    end
end

endmodule