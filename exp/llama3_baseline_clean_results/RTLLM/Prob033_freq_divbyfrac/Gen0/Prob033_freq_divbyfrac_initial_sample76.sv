module freq_divbyfrac (
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7; // Multiplier for fractional division (3.5x)
localparam DIV_CLK_HALF_PERIOD = MUL2_DIV_CLK / 2; // Half period for phase shifting

reg [2:0] counter; // Counter for tracking clock cycles
reg clk_int1, clk_int2; // Intermediate divided clock signals
reg clk_int1_delayed, clk_int2_advanced; // Phase-shifted intermediate clocks

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active low reset
        counter <= 0;
        clk_int1 <= 0;
        clk_int2 <= 0;
        clk_int1_delayed <= 0;
        clk_int2_advanced <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin // Reset counter after reaching MUL2_DIV_CLK
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate divided clocks (4 and 3 source clock cycles)
        if (counter < DIV_CLK_HALF_PERIOD) begin
            clk_int1 <= (counter == 0) ? 1'b1 : 1'b0;
        end else begin
            clk_int1 <= (counter == DIV_CLK_HALF_PERIOD) ? 1'b1 : 1'b0;
        end

        if (counter >= DIV_CLK_HALF_PERIOD) begin
            if (counter == DIV_CLK_HALF_PERIOD) begin
                clk_int2 <= 1'b1;
            end else begin
                clk_int2 <= 1'b0;
            end
        end

        // Phase shift intermediate clocks
        if (counter == 0) begin
            clk_int1_delayed <= 1'b1;
        end else if (counter == 1) begin
            clk_int1_delayed <= 1'b0;
        end

        if (counter == MUL2_DIV_CLK - 1) begin
            clk_int2_advanced <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_int2_advanced <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(*) begin
    clk_div = (clk_int1 || clk_int1_delayed || clk_int2 || clk_int2_advanced);
end

endmodule