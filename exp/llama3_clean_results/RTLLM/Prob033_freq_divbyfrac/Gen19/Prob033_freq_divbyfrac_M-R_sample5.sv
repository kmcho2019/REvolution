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
reg [1:0] cnt_4;  // Counter for 4x division
reg [1:0] cnt_3;  // Counter for 3x division
reg clk_div_4;  // Divided clock signal for 4x division
reg clk_div_3;  // Divided clock signal for 3x division
reg clk_div_4_delayed;  // Delayed version of divided clock signal for 4x division
reg clk_div_3_delayed;  // Delayed version of divided clock signal for 3x division

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_4 <= 2'b00;
        cnt_3 <= 2'b00;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_delayed <= 1'b0;
        clk_div_3_delayed <= 1'b0;
    end else begin
        // Counter for 4x division
        if (cnt_4 == CLK_4 - 1) begin
            cnt_4 <= 2'b00;
        end else begin
            cnt_4 <= cnt_4 + 1'b1;
        end
        
        // Counter for 3x division
        if (cnt_3 == CLK_3 - 1) begin
            cnt_3 <= 2'b00;
        end else begin
            cnt_3 <= cnt_3 + 1'b1;
        end
        
        // Generate divided clock signal for 4x division
        if (cnt_4 == CLK_4 - 1) begin
            clk_div_4 <= 1'b1;
        end else begin
            clk_div_4 <= 1'b0;
        end
        
        // Generate divided clock signal for 3x division
        if (cnt_3 == CLK_3 - 1) begin
            clk_div_3 <= 1'b1;
        end else begin
            clk_div_3 <= 1'b0;
        end
        
        // Delay divided clock signal for 4x division by half a clock period
        clk_div_4_delayed <= clk_div_4;
        
        // Delay divided clock signal for 3x division by half a clock period
        clk_div_3_delayed <= clk_div_3;
    end
end

// Combinational logic for final divided clock output
assign clk_div = (clk_div_4 && ~clk_div_4_delayed) || (clk_div_3 && ~clk_div_3_delayed);

endmodule