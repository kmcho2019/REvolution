module freq_divbyfrac (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output clk_div // Fractionally divided clock output
);

// Define the counter width
localparam CNT_WIDTH = 3;

// Define the counter value for the first and second uneven clock periods
localparam MUL2_DIV_CLK = 7;
localparam CLK_PERIOD1 = 4;
localparam CLK_PERIOD2 = 3;

// Declare the counter signal
reg [CNT_WIDTH-1:0] cnt;

// Declare the intermediate divided clock signals
reg clk_div_int1;
reg clk_div_int2;

// Declare the phase-shifted intermediate clock signals
reg clk_div_int1_delayed;
reg clk_div_int2_advanced;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Generate intermediate divided clock signals
        if (cnt < CLK_PERIOD1) begin
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end
        
        if ((cnt >= CLK_PERIOD1) && (cnt < MUL2_DIV_CLK)) begin
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk) begin
    // Delay clk_div_int1 by half a clock period
    clk_div_int1_delayed <= clk_div_int1;
    
    // Advance clk_div_int2 by half a clock period
    if (clk_div_int2) begin
        clk_div_int2_advanced <= 1;
    end else if (clk_div_int2_advanced) begin
        clk_div_int2_advanced <= 0;
    end
end

// Final fractionally divided clock output
assign clk_div = clk_div_int1_delayed | clk_div_int2_advanced;

endmodule