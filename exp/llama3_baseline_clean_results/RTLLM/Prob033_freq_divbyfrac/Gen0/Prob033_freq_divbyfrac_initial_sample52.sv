module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the parameters for the frequency division
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles in a division period
parameter DIV_CLK_1 = 4;    // Length of the first divided clock period
parameter DIV_CLK_2 = 3;    // Length of the second divided clock period

// Internal signals
reg [2:0] counter;          // Counter to cycle through the division periods
reg clk_div_int1;           // First intermediate divided clock
reg clk_div_int2;           // Second intermediate divided clock
reg clk_div_int1_delayed;   // Delayed version of the first intermediate clock
reg clk_div_int2_advanced;  // Advanced version of the second intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate intermediate clocks based on the counter value
        if (counter < DIV_CLK_1) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if ((counter >= DIV_CLK_1) && (counter < MUL2_DIV_CLK)) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        // Delay the first intermediate clock by half a clock period
        clk_div_int1_delayed <= clk_div_int1;

        // Advance the second intermediate clock by half a clock period
        if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int2_advanced <= 1'b1;
        end else if (counter == 0) begin
            clk_div_int2_advanced <= 1'b0;
        end else begin
            clk_div_int2_advanced <= clk_div_int2;
        end
    end
end

// Final divided clock output
assign clk_div = clk_div_int1_delayed | clk_div_int2_advanced;

endmodule