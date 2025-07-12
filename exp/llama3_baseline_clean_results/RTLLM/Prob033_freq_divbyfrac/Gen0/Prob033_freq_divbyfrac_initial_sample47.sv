module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Constants
localparam MUL2_DIV_CLK = 7; // Count of clock cycles for 3.5x division
localparam HIGH_COUNT = 4; // Count of high clock cycles
localparam LOW_COUNT = 3; // Count of low clock cycles

// Internal signals
reg [2:0] counter; // Counter to cycle through MUL2_DIV_CLK clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_int1_delayed; // Delayed version of clk_div_int1
reg clk_div_int2_advanced; // Advanced version of clk_div_int2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int1 <= 1'b0; // Reset intermediate clock signals
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end
        
        // Generate intermediate clock signals
        if (counter < HIGH_COUNT) begin
            clk_div_int1 <= 1'b1; // High clock cycles
        end else begin
            clk_div_int1 <= 1'b0; // Low clock cycles
        end
        
        if (counter < LOW_COUNT) begin
            clk_div_int2 <= 1'b1; // High clock cycles
        end else begin
            clk_div_int2 <= 1'b0; // Low clock cycles
        end
        
        // Phase-shift intermediate clock signals
        if (~rst_n) begin
            clk_div_int1_delayed <= 1'b0;
            clk_div_int2_advanced <= 1'b0;
        end else begin
            if (counter == HIGH_COUNT - 1) begin
                clk_div_int1_delayed <= 1'b1; // Delayed version of clk_div_int1
            end else if (counter == MUL2_DIV_CLK - 1) begin
                clk_div_int1_delayed <= 1'b0;
            end else begin
                clk_div_int1_delayed <= clk_div_int1_delayed;
            end
            
            if (counter == LOW_COUNT - 1) begin
                clk_div_int2_advanced <= 1'b1; // Advanced version of clk_div_int2
            end else if (counter == MUL2_DIV_CLK - 1) begin
                clk_div_int2_advanced <= 1'b0;
            end else begin
                clk_div_int2_advanced <= clk_div_int2_advanced;
            end
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0; // Reset output clock
    end else begin
        clk_div <= clk_div_int1_delayed | clk_div_int2_advanced; // Logically OR-ed output
    end
end

endmodule