module freq_divbyfrac (
    input  clk,     // Input clock signal
    input  rst_n,   // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Define the multiplier for fractional division (3.5x)
localparam MUL2_DIV_CLK = 7;

// Counter to keep track of clock cycles for division
reg [2:0] cnt;

// Intermediate divided clock signals
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_delayed;
reg clk_div_3_advanced;

// Counter to generate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        cnt <= cnt + 1'b1;
        
        // Generate clk_div_4 (4 source clock cycles)
        if (cnt == 3'b100) begin
            clk_div_4 <= 1'b1;
        end else if (cnt == 3'b000) begin
            clk_div_4 <= 1'b0;
        end
        
        // Generate clk_div_3 (3 source clock cycles)
        if (cnt == 3'b011) begin
            clk_div_3 <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shifting the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_delayed <= 1'b0;
        clk_div_3_advanced <= 1'b0;
    end else begin
        // Delay clk_div_4 by half a clock period
        if (cnt == 3'b101) begin
            clk_div_4_delayed <= clk_div_4;
        end
        
        // Advance clk_div_3 by half a clock period
        if (cnt == 3'b010) begin
            clk_div_3_advanced <= clk_div_3;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted clocks
        clk_div <= clk_div_4 | clk_div_3_advanced | clk_div_4_delayed;
    end
end

endmodule