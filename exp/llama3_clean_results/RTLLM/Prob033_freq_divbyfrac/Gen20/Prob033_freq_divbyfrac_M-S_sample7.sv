module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for counter
reg [2:0] counter;  // Current counter value

// Signals for intermediate clock signals
reg clk_div1, clk_div2;  // Intermediate clock signals

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;  // Initialize counter to 0
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Update counter value based on current counter value
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
            if (clk_div1 == 1'b1) begin
                clk_div1 <= 1'b0;
            end else if (counter == 3'd3) begin
                clk_div1 <= 1'b1;
            end

            if (clk_div2 == 1'b1) begin
                clk_div2 <= 1'b0;
            end else if (counter == 3'd6) begin
                clk_div2 <= 1'b1;
            end
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Phase-shifting and OR-ing
assign clk_div = clk_div1 || clk_div2;

endmodule