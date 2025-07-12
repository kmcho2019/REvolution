module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional frequency division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CLK_HALF = MUL2_DIV_CLK / 2; // Half of the total clock cycles
parameter CLK_HALF_PERIOD = 1; // Half clock period (1 for double-edge clocking)

// Internal signals
reg [2:0] counter; // Counter for 7 clock cycles
reg clk_div_int1; // Intermediate divided clock signal (4 source clock cycles)
reg clk_div_int2; // Intermediate divided clock signal (3 source clock cycles)
reg clk_div_delayed; // Delayed version of divided clock signal
reg clk_div_advanced; // Advanced version of divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Generate intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        if (counter == 3) begin
            clk_div_int1 <= 1'b1;
        end else if (counter == 6) begin
            clk_div_int1 <= 1'b0;
        end
        
        if (counter == 0) begin
            clk_div_int2 <= 1'b1;
        end else if (counter == 3) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Generate phase-shifted versions of divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        if (counter == 2) begin
            clk_div_delayed <= 1'b1;
        end else if (counter == 5) begin
            clk_div_delayed <= 1'b0;
        end
        
        if (counter == 1) begin
            clk_div_advanced <= 1'b1;
        end else if (counter == 4) begin
            clk_div_advanced <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_int1 | clk_div_advanced | clk_div_delayed;

endmodule