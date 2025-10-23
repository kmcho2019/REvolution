module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
parameter MUL2_DIV_CLK = 7; // Number of clock cycles for the counter
parameter DIV CLK_HIGH = 4; // Number of clock cycles for the high period
parameter DIV CLK_LOW = 3; // Number of clock cycles for the low period

reg [2:0] counter; // Counter to cycle through MUL2_DIV_CLK
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_delayed; // Delayed version of the intermediate clock
reg clk_div_advanced; // Advanced version of the intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter on rst_n low
        clk_div_int <= 1'b0; // Reset intermediate clock on rst_n low
        clk_div_delayed <= 1'b0; // Reset delayed clock on rst_n low
        clk_div_advanced <= 1'b0; // Reset advanced clock on rst_n low
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter after reaching MUL2_DIV_CLK
        end else begin
            counter <= counter + 1'b1; // Increment counter on each clock cycle
        end
        
        // Generate intermediate divided clock signal
        if (counter < DIV_CLK_HIGH) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
        
        // Phase shifting: delay and advance the intermediate clock
        if (counter == 1) begin
            clk_div_delayed <= clk_div_int;
        end else begin
            clk_div_delayed <= clk_div_delayed;
        end
        
        if (counter == 0) begin
            clk_div_advanced <= clk_div_int;
        end else begin
            clk_div_advanced <= clk_div_int;
        end
    end
end

// Final divided clock output: logically OR the phase-shifted clocks
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule