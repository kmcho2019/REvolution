module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter CLK_4 = 4;  // Clock cycles for 4x division
parameter CLK_3 = 3;  // Clock cycles for 3x division

// Internal signals
reg [1:0] cnt;  // Counter for 4x and 3x division
reg clk_div_4;  // Divided clock signal for 4x division
reg clk_div_3;  // Divided clock signal for 3x division
reg prev_clk_div_4;  // Previous divided clock signal for 4x division
reg prev_clk_div_3;  // Previous divided clock signal for 3x division

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        prev_clk_div_4 <= 1'b0;
        prev_clk_div_3 <= 1'b0;
    end else begin
        // Counter for 4x and 3x division
        cnt <= (cnt == 2'b11)? 2'b00 : cnt + 1'b1;
        
        // Generate divided clock signal for 4x division
        if (cnt == 2'b11) begin
            clk_div_4 <= 1'b1;
        end else begin
            clk_div_4 <= 1'b0;
        end
        
        // Generate divided clock signal for 3x division
        if (cnt == 2'b10) begin
            clk_div_3 <= 1'b1;
        end else begin
            clk_div_3 <= 1'b0;
        end
        
        // Delay divided clock signal for 4x division by half a clock period
        prev_clk_div_4 <= clk_div_4;
        
        // Delay divided clock signal for 3x division by half a clock period
        prev_clk_div_3 <= clk_div_3;
    end
end

// Combinational logic for final divided clock output
assign clk_div = (clk_div_4 && ~prev_clk_div_4) || (clk_div_3 && ~prev_clk_div_3);

endmodule