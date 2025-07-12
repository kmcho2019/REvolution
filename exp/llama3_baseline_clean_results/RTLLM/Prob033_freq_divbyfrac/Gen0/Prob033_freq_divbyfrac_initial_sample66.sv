module freq_divbyfrac(
    input  clk,
    input  rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division

// Internal signals
reg [2:0] cnt; // Counter to cycle through MUL2_DIV_CLK clock cycles
reg clk_div_int1; // Intermediate divided clock 1 (4 clock cycles)
reg clk_div_int2; // Intermediate divided clock 2 (3 clock cycles)
reg clk_div_int1_dly; // Delayed version of clk_div_int1 by half a clock period
reg clk_div_int2_adv; // Advanced version of clk_div_int2 by half a clock period

// Combinational logic to generate intermediate divided clocks
always @(*) begin
    if (cnt == 4'd4) begin
        clk_div_int1 = 1'b1;
    end else begin
        clk_div_int1 = 1'b0;
    end
    
    if (cnt == 4'd3) begin
        clk_div_int2 = 1'b1;
    end else begin
        clk_div_int2 = 1'b0;
    end
end

// Sequential logic to generate phase-shifted clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'd0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'd0;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Double-edge clocking to generate phase-shifted clocks
        if (clk == 1'b1) begin // Rising edge
            clk_div_int1_dly <= clk_div_int1;
        end
        
        if (clk == 1'b0) begin // Falling edge
            clk_div_int2_adv <= clk_div_int2;
        end
    end
end

// Final output generation using logical OR
always @(*) begin
    clk_div = clk_div_int1_dly | clk_div_int2_adv;
end

endmodule