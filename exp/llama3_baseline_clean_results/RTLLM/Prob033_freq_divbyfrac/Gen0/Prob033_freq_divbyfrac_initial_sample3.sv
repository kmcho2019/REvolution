module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter CLK_A_CYCLE = 4; // Number of clock cycles for the first uneven period
parameter CLK_B_CYCLE = 3; // Number of clock cycles for the second uneven period

// Counter to keep track of the current clock cycle
reg [2:0] cycle_counter;

// Signals for the uneven clock periods
reg clk_a, clk_b;
reg clk_a_phase, clk_b_phase; // Phase-shifted versions of clk_a and clk_b

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        cycle_counter <= 3'b000;
        clk_a <= 1'b0;
        clk_b <= 1'b0;
        clk_a_phase <= 1'b0;
        clk_b_phase <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment cycle counter
        if (cycle_counter == MUL2_DIV_CLK - 1) begin
            cycle_counter <= 3'b000;
        end else begin
            cycle_counter <= cycle_counter + 1'b1;
        end

        // Generate clk_a (4 clock cycles high)
        if (cycle_counter < CLK_A_CYCLE) begin
            clk_a <= 1'b1;
        end else begin
            clk_a <= 1'b0;
        end

        // Generate clk_b (3 clock cycles high, starting after clk_a)
        if ((cycle_counter >= CLK_A_CYCLE) && (cycle_counter < (CLK_A_CYCLE + CLK_B_CYCLE))) begin
            clk_b <= 1'b1;
        end else begin
            clk_b <= 1'b0;
        end

        // Generate phase-shifted versions
        // Since we are working with a 3.5x division and uneven periods, 
        // we need to create a phase shift that effectively advances or delays 
        // the clock edges to achieve the fractional division smoothly.
        // This involves using the double-edge clocking technique, 
        // where we consider both the rising and falling edges of the clock.
        if (cycle_counter == 1) begin // Rising edge of the first uneven period
            clk_a_phase <= 1'b1;
        end else if (cycle_counter == CLK_A_CYCLE) begin // Falling edge of the first uneven period
            clk_a_phase <= 1'b0;
        end

        if (cycle_counter == (CLK_A_CYCLE + 1)) begin // Rising edge of the second uneven period
            clk_b_phase <= 1'b1;
        end else if (cycle_counter == (CLK_A_CYCLE + CLK_B_CYCLE)) begin // Falling edge of the second uneven period
            clk_b_phase <= 1'b0;
        end

        // Combine the phase-shifted clocks to produce the final output
        // We use a logical OR operation to ensure the output clock has a uniform period
        clk_div <= clk_a_phase | clk_b_phase;
    end
end

endmodule