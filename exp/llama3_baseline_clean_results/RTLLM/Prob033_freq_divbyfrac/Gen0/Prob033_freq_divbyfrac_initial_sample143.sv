module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Counter to track clock cycles
reg [2:0] cnt;
reg [2:0] next_cnt;

// Intermediate clock signal
reg clk_int;
reg next_clk_int;

// Phase-shifted clocks
reg clk_int_delayed;
reg clk_int_advanced;
reg next_clk_int_delayed;
reg next_clk_int_advanced;

// Constants
localparam MUL2_DIV_CLK = 7;

always @(*) begin
    // Counter logic
    if (!rst_n) begin
        next_cnt = 0;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        next_cnt = 0;
    end else begin
        next_cnt = cnt + 1;
    end
    
    // Intermediate clock logic
    if (cnt < 4) begin
        next_clk_int = 1;
    end else begin
        next_clk_int = 0;
    end
    
    // Phase-shifted clocks logic
    next_clk_int_delayed = (cnt == 3) ? 1 : (cnt == 6) ? 0 : clk_int_delayed;
    next_clk_int_advanced = (cnt == 0) ? 1 : (cnt == 3) ? 0 : clk_int_advanced;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_int <= 0;
        clk_int_delayed <= 0;
        clk_int_advanced <= 0;
    end else begin
        cnt <= next_cnt;
        clk_int <= next_clk_int;
        clk_int_delayed <= next_clk_int_delayed;
        clk_int_advanced <= next_clk_int_advanced;
    end
end

assign clk_div = clk_int_delayed | clk_int_advanced;

endmodule