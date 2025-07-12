module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg clk_div_delayed;  // Delayed version of divided clock
reg clk_div_advanced;  // Advanced version of divided clock

// Counter logic and phase-shifting mechanism
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        cnt <= cnt + 1'b1;  // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
        end

        // Generate intermediate divided clocks
        if (cnt < 4) begin
            clk_div_int1 <= 1'b1;  // 4 cycles clock
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt >= 4) begin
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Phase-shifting mechanism
        if (cnt == 0) begin
            clk_div_delayed <= 1'b1;  // Delayed version of divided clock
        end else if (cnt == 4) begin
            clk_div_delayed <= 1'b0;
        end

        if (cnt == 3) begin
            clk_div_advanced <= 1'b1;  // Advanced version of divided clock
        end else if (cnt == 7 - 1) begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule