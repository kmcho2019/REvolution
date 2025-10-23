module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock signal 1 (4 cycles)
reg clk_div_int2;  // Intermediate divided clock signal 2 (3 cycles)
reg clk_div_int1_delayed;  // Delayed version of clk_div_int1
reg clk_div_int2_advanced;  // Advanced version of clk_div_int2

// Sequential logic for counter and intermediate clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < MUL2_DIV_CLK - 1) begin
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 3'b000;
        end
        // Generate intermediate clock signals based on counter value
        if (cnt >= 3'b000 && cnt < 3'b100) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end
        if (cnt >= 3'b100 && cnt < MUL2_DIV_CLK) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
        // Delay and advance intermediate clock signals
        clk_div_int1_delayed <= clk_div_int1;
        if (cnt == 3'b000) begin
            clk_div_int2_advanced <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_int2_advanced <= 1'b0;
        end else begin
            clk_div_int2_advanced <= clk_div_int2;
        end
    end
end

// Phase-shifting logic to generate final clk_div signal
assign clk_div = (clk_div_int1 | clk_div_int1_delayed) | (clk_div_int2 | clk_div_int2_advanced);

endmodule