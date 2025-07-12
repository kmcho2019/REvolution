module freq_divbyfrac (
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for the division
parameter DIV_CLK_HALF_PERIOD = 1;  // Half period for phase shifting

// Internal signals
reg [2:0] counter;  // Counter for cycling through clock cycles
reg clk_int_4;  // Intermediate clock with 4 source clock cycles
reg clk_int_3;  // Intermediate clock with 3 source clock cycles
reg clk_phase_delayed;  // Phase-delayed clock
reg clk_phase_advanced;  // Phase-advanced clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_int_4 <= 0;
        clk_int_3 <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate clocks with uneven periods
        if (counter < 4) begin
            clk_int_4 <= 1;
        end else begin
            clk_int_4 <= 0;
        end

        if (counter < 3) begin
            clk_int_3 <= 1;
        end else begin
            clk_int_3 <= 0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase_delayed <= 0;
        clk_phase_advanced <= 0;
    end else begin
        // Phase-delayed clock (half period delayed)
        if (clk_int_4) begin
            clk_phase_delayed <= (counter == 3);
        end else begin
            clk_phase_delayed <= 0;
        end

        // Phase-advanced clock (half period advanced)
        if (clk_int_3) begin
            clk_phase_advanced <= (counter == 2);
        end else begin
            clk_phase_advanced <= 0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_phase_delayed | clk_phase_advanced;

endmodule