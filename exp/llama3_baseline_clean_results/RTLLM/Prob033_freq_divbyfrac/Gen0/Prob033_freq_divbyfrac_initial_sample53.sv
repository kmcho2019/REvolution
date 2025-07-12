module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Constants for 3.5x division
localparam MUL2_DIV_CLK = 7; // Total cycles for 3.5x division
localparam DIV_CYCLES_LONG = 4; // Cycles for longer phase
localparam DIV_CYCLES_SHORT = 3; // Cycles for shorter phase

// Counter to keep track of the current cycle
reg [2:0] cycle_cnt;

// Signals for the two phases of the divided clock
reg clk_div_long, clk_div_short;

// Phase-shifted versions of the divided clocks
reg clk_div_long_delayed, clk_div_short_advanced;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        cycle_cnt <= 3'b0;
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
    end else begin
        // Increment the cycle counter
        if (cycle_cnt == MUL2_DIV_CLK - 1) begin
            cycle_cnt <= 3'b0;
        end else begin
            cycle_cnt <= cycle_cnt + 1'b1;
        end

        // Generate the two phases of the divided clock
        if (cycle_cnt == DIV_CYCLES_LONG - 1) begin
            clk_div_long <= 1'b1;
        end else if (cycle_cnt == MUL2_DIV_CLK - 1) begin
            clk_div_long <= 1'b0;
        end

        if (cycle_cnt == DIV_CYCLES_SHORT - 1) begin
            clk_div_short <= 1'b1;
        end else if (cycle_cnt == DIV_CYCLES_LONG) begin
            clk_div_short <= 1'b0;
        end
    end
end

// Phase-shifting the divided clocks
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long_delayed <= 1'b0;
        clk_div_short_advanced <= 1'b0;
    end else begin
        // Delay clk_div_long by half a clock period
        if (clk_div_long) begin
            clk_div_long_delayed <= ~clk_div_long;
        end else begin
            clk_div_long_delayed <= 1'b0;
        end

        // Advance clk_div_short by half a clock period
        if (clk_div_short) begin
            clk_div_short_advanced <= ~clk_div_short;
        end else begin
            clk_div_short_advanced <= 1'b0;
        end
    end
end

// Final divided clock output
always @ (*) begin
    // Logically OR the phase-shifted clocks to get the final divided clock
    clk_div = clk_div_long_delayed | clk_div_short_advanced;
end

endmodule