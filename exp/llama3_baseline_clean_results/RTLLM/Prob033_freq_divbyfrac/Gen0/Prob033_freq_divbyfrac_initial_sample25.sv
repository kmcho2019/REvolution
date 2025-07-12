module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for the divider
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles for 3.5x division
parameter DIV CLK_CYCLES1 = 4; // Number of clock cycles for first divided clock period
parameter DIV_CLK_CYCLES2 = 3; // Number of clock cycles for second divided clock period

// Internal signals
reg [2:0] counter; // Counter to keep track of the clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_delayed; // Delayed version of the divided clock signal
reg clk_div_advanced; // Advanced version of the divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate intermediate divided clock signals
        if (counter < DIV_CLK_CYCLES1) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (counter >= DIV_CLK_CYCLES1 && counter < MUL2_DIV_CLK) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        // Delayed version of the divided clock signal
        if (counter == 1) begin
            clk_div_delayed <= clk_div_int1;
        end else if (counter == 2) begin
            clk_div_delayed <= clk_div_int2;
        end else begin
            clk_div_delayed <= 1'b0;
        end

        // Advanced version of the divided clock signal
        if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_advanced <= clk_div_int1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_advanced <= clk_div_int2;
        end else begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Final divided clock output
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule