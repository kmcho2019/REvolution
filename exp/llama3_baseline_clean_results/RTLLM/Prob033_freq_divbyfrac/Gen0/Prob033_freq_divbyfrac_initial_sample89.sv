module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;
parameter DIV_CLK_HIGH = 4;
parameter DIV_CLK_LOW = 3;

reg [2:0] counter; // 3-bit counter to cycle through 7 clock cycles
reg clk_div_int1; // Intermediate clock 1 (4 cycles high, 3 cycles low)
reg clk_div_int2; // Intermediate clock 2 (3 cycles high, 4 cycles low)
reg clk_div_int1_d; // Delayed version of clk_div_int1 by half a clock period
reg clk_div_int2_a; // Advanced version of clk_div_int2 by half a clock period

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Wrap around counter
    end else begin
        counter <= counter + 1;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (counter < DIV_CLK_HIGH) begin
        clk_div_int1 <= 1'b1;
    end else begin
        clk_div_int1 <= 1'b0;
    end

    if (~rst_n) begin
        clk_div_int2 <= 1'b0;
    end else if (counter < DIV_CLK_LOW) begin
        clk_div_int2 <= 1'b1;
    end else begin
        clk_div_int2 <= 1'b0;
    end
end

// Phase-shifting logic using double-edge clocking
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_d <= 1'b0;
    end else begin
        clk_div_int1_d <= clk_div_int1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int2_a <= 1'b0;
    end else begin
        clk_div_int2_a <= clk_div_int2;
    end
end

// Final clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_int1_d | clk_div_int2_a;
    end
end

endmodule