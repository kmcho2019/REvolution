module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CLK_CYCLES_1 = 4; // Clock cycles for first divided clock period
parameter DIV_CLK_CYCLES_2 = 3; // Clock cycles for second divided clock period

// Internal signals
reg [2:0] counter; // Counter for clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_int1_delayed; // Delayed version of intermediate divided clock signal 1
reg clk_div_int2_advanced; // Advanced version of intermediate divided clock signal 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate intermediate divided clock signals
        if (counter < DIV_CLK_CYCLES_1) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end
        
        if ((counter >= DIV_CLK_CYCLES_1) && (counter < MUL2_DIV_CLK)) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end
        
        // Generate phase-shifted versions of intermediate divided clock signals
        clk_div_int1_delayed <= clk_div_int1;
        clk_div_int2_advanced <= clk_div_int2;
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // OR the phase-shifted intermediate clocks to produce the final output
        if (clk_div_int1_delayed || clk_div_int2_advanced) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule