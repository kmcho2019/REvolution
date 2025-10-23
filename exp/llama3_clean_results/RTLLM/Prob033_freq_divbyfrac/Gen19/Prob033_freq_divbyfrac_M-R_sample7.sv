module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter CLK_4 = 4;  // Clock cycles for 4x division
parameter CLK_3 = 3;  // Clock cycles for 3x division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter for 3.5x division
reg clk_div_4;  // Divided clock signal for 4x division
reg clk_div_3;  // Divided clock signal for 3x division
reg clk_div_4_delayed;  // Delayed version of divided clock signal for 4x division
reg clk_div_3_delayed;  // Delayed version of divided clock signal for 3x division

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate divided clock signal for 4x division
assign clk_div_4 = (cnt == CLK_4 - 1);

// Generate divided clock signal for 3x division
assign clk_div_3 = (cnt == MUL2_DIV_CLK - 1);

// Delay divided clock signal for 4x division by half a clock period
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_delayed <= 1'b0;
    end else begin
        clk_div_4_delayed <= clk_div_4;
    end
end

// Delay divided clock signal for 3x division by half a clock period
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_3_delayed <= 1'b0;
    end else begin
        clk_div_3_delayed <= clk_div_3;
    end
end

// Combinational logic for final divided clock output
assign clk_div = (clk_div_4 && !clk_div_4_delayed) || (clk_div_3 && !clk_div_3_delayed);

endmodule