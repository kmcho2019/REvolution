module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] count; // Counter to cycle through 7 clock cycles
reg clk_div_int1; // Intermediate divided clock 1 (4 source clock cycles)
reg clk_div_int2; // Intermediate divided clock 2 (3 source clock cycles)
reg clk_div_delayed; // Delayed version of clk_div_int1
reg clk_div_advanced; // Advanced version of clk_div_int2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'd0;
    end else begin
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 3'd0;
        end else begin
            count <= count + 1'd1;
        end
    end
end

// Generate intermediate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1 <= 1'd0;
        clk_div_int2 <= 1'd0;
    end else begin
        if (count == 3'd3) begin // 4 source clock cycles
            clk_div_int1 <= 1'd1;
        end else if (count == 3'd7) begin
            clk_div_int1 <= 1'd0;
        end
        
        if (count == 3'd0) begin // 3 source clock cycles
            clk_div_int2 <= 1'd1;
        end else if (count == 3'd3) begin
            clk_div_int2 <= 1'd0;
        end
    end
end

// Generate phase-shifted versions of intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'd0;
        clk_div_advanced <= 1'd0;
    end else begin
        // Delay clk_div_int1 by half a clock period
        if (count == 3'd4) begin
            clk_div_delayed <= 1'd1;
        end else if (count == 3'd7) begin
            clk_div_delayed <= 1'd0;
        end
        
        // Advance clk_div_int2 by half a clock period
        if (count == 3'd0) begin
            clk_div_advanced <= 1'd1;
        end else if (count == 3'd3) begin
            clk_div_advanced <= 1'd0;
        end
    end
end

// Generate final fractional divided clock output
always @(*) begin
    clk_div = clk_div_int1 | clk_div_int2 | clk_div_delayed | clk_div_advanced;
end

endmodule