module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
localparam DIV_BY_4 = 4;      // Clock cycles for first divided clock period
localparam DIV_BY_3 = 3;      // Clock cycles for second divided clock period

// Internal signals
reg [2:0] cnt;               // Counter to keep track of clock cycles
reg clk_div_int1;            // First intermediate divided clock signal
reg clk_div_int2;            // Second intermediate divided clock signal
reg clk_div_int1_phase;      // Phase-shifted first intermediate divided clock signal
reg clk_div_int2_phase;      // Phase-shifted second intermediate divided clock signal
reg prev_clk;                // Previous clock value for edge detection

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Generate intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (cnt == DIV_BY_4 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int1 <= 1'b0;
        end
        
        if (cnt == DIV_BY_3 - 1) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == DIV_BY_3 + DIV_BY_4 - 1) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_clk <= 1'b0;
    end else begin
        prev_clk <= clk;
    end
end

assign clk_div_int1_phase = (cnt == DIV_BY_4 - 2) ? 1'b1 : (prev_clk && !clk) ? 1'b1 : 1'b0;
assign clk_div_int2_phase = (cnt == DIV_BY_3 + DIV_BY_4 - 2) ? 1'b1 : (prev_clk && !clk) ? 1'b1 : 1'b0;

// Final fractional divided clock output
assign clk_div = clk_div_int1 || clk_div_int2 || clk_div_int1_phase || clk_div_int2_phase;

endmodule