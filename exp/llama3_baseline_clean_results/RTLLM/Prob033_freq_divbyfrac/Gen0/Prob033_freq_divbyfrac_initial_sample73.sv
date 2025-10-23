module freq_divbyfrac(
    input         clk,
    input         rst_n,
    output        clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for one complete division cycle
parameter DIV_CLK_HI = 4;   // Number of clock cycles for the longer divided clock period
parameter DIV_CLK_LO = 3;   // Number of clock cycles for the shorter divided clock period

// Internal signals
reg [2:0] count; // Counter to cycle through MUL2_DIV_CLK
reg clk_div_lo;  // Low-duty cycle divided clock
reg clk_div_hi;  // High-duty cycle divided clock
reg clk_div_hi_dly; // Delayed version of clk_div_hi for phase shifting
reg clk_div_lo_adv; // Advanced version of clk_div_lo for phase shifting

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;
        clk_div_lo <= 1'b0;
        clk_div_hi <= 1'b0;
        clk_div_hi_dly <= 1'b0;
        clk_div_lo_adv <= 1'b0;
    end else begin
        // Count through MUL2_DIV_CLK cycles
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 3'b000;
        end else begin
            count <= count + 1'b1;
        end
        
        // Generate divided clocks
        if (count < DIV_CLK_HI) begin
            clk_div_hi <= 1'b1;
        end else begin
            clk_div_hi <= 1'b0;
        end
        
        if (count < DIV_CLK_LO) begin
            clk_div_lo <= 1'b1;
        end else begin
            clk_div_lo <= 1'b0;
        end
        
        // Phase shift divided clocks for double-edge clocking
        // Delay clk_div_hi by half a clock cycle
        if (count == DIV_CLK_HI - 1) begin
            clk_div_hi_dly <= 1'b1;
        end else if (count == MUL2_DIV_CLK - 1) begin
            clk_div_hi_dly <= 1'b0;
        end else begin
            clk_div_hi_dly <= clk_div_hi_dly;
        end
        
        // Advance clk_div_lo by half a clock cycle
        if (count == DIV_CLK_LO) begin
            clk_div_lo_adv <= 1'b1;
        end else if (count == MUL2_DIV_CLK - 1) begin
            clk_div_lo_adv <= 1'b0;
        end else begin
            clk_div_lo_adv <= clk_div_lo_adv;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_lo | clk_div_hi_dly;

endmodule