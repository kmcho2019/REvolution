module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg [2:0] counter;
reg clk_div_4;
reg clk_div_3;
reg delayed_clk_div_4;
reg advanced_clk_div_3;

// Sequential logic to update counter and state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        delayed_clk_div_4 <= 1'b0;
        advanced_clk_div_3 <= 1'b0;
    end else begin
        // Counter to track clock cycles
        if (counter < MUL2_DIV_CLK - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 3'd0;
        end

        // Generate uneven clock periods
        if (counter == 3'd0) begin
            clk_div_4 <= 1'b1;
        end else if (counter == 3'd3) begin
            clk_div_4 <= 1'b0;
        end

        if (counter == 3'd4) begin
            clk_div_3 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_3 <= 1'b0;
        end

        // Delay and advance clock signals
        delayed_clk_div_4 <= clk_div_4;
        advanced_clk_div_3 <= clk_div_3;
    end
end

// Combinational logic to generate final divided clock output
assign clk_div = (clk_div_4 & ~advanced_clk_div_3) | (~delayed_clk_div_4 & clk_div_3);

endmodule