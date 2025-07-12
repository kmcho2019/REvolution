module freq_divbyfrac(
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter HIGH_CYCLES = 4;  // Clock cycles for the longer period
parameter LOW_CYCLES = 3;  // Clock cycles for the shorter period

reg [2:0] counter; // Counter to track clock cycles
reg clk_int;       // Intermediate divided clock signal
reg clk_int_delayed; // Delayed intermediate clock signal
reg clk_int_advanced; // Advanced intermediate clock signal
reg clk_div_reg;    // Register for the final divided clock output

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        clk_int <= ~clk_int;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate intermediate clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int_delayed <= 1'b0;
        clk_int_advanced <= 1'b0;
    end else begin
        if (counter == HIGH_CYCLES - 1) begin
            clk_int_delayed <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int_delayed <= 1'b0;
        end

        if (counter == LOW_CYCLES - 1) begin
            clk_int_advanced <= 1'b1;
        end else if (counter == HIGH_CYCLES - 1) begin
            clk_int_advanced <= 1'b0;
        end
    end
end

// Double-edge clocking technique
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_reg <= 1'b0;
    end else begin
        clk_div_reg <= clk_int_delayed | clk_int_advanced;
    end
end

// Final divided clock output
assign clk_div = clk_div_reg;

endmodule