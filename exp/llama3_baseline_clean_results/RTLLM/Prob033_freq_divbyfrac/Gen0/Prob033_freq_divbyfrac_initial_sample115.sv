module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for the multiplication factor and division factor
localparam MUL2_DIV_CLK = 7; // For 3.5x division, 3.5 * 2 = 7

// Internal signals for clock counters and phase-shifted clocks
reg [2:0] count; // Counter for 7 clock cycles
reg clk_int1, clk_int2; // Intermediate clocks for phase-shifting
reg prev_clk_int1, prev_clk_int2; // Previous states of intermediate clocks

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'd0; // Reset counter
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        prev_clk_int1 <= 1'b0;
        prev_clk_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter every clock cycle
        count <= count + 1'd1;
        
        // Generate intermediate clocks with uneven periods
        if (count == 3'd4) begin // 4 clock cycles for one period
            clk_int1 <= 1'b1;
        end else if (count == 3'd7) begin // Reset after 7 cycles
            clk_int1 <= 1'b0;
        end
        
        if (count == 3'd3) begin // 3 clock cycles for the other period
            clk_int2 <= 1'b1;
        end else if (count == 3'd6) begin // Reset after 6 cycles for the second period
            clk_int2 <= 1'b0;
        end
        
        // Phase-shift intermediate clocks by half a clock period
        // This is achieved by using the previous state of the clocks
        // to create a delayed and an advanced phase
        if (prev_clk_int1 == 1'b1 && clk_int1 == 1'b0) begin // Falling edge detection for delay
            clk_div <= 1'b1; // Set output high on delayed phase
        end else if (prev_clk_int2 == 1'b0 && clk_int2 == 1'b1) begin // Rising edge detection for advance
            clk_div <= 1'b1; // Set output high on advanced phase
        end else begin
            clk_div <= 1'b0; // Reset output otherwise
        end
        
        // Store previous states of intermediate clocks
        prev_clk_int1 <= clk_int1;
        prev_clk_int2 <= clk_int2;
    end
end

endmodule