module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Constants for division ratio and total cycles
localparam MUL2_DIV_CLK = 7; // Total cycles for 3.5x division (4+3)
localparam DIV_RATIO_1 = 4;   // First part of the division ratio
localparam DIV_RATIO_2 = 3;   // Second part of the division ratio

// Internal signals
reg [2:0] cycle_cnt; // Counter for tracking the main clock cycle
reg [1:0] state;     // State machine for handling the division
reg clk_div_int1;    // Intermediate clock 1 (4 cycles)
reg clk_div_int2;    // Intermediate clock 2 (3 cycles)
reg clk_div_phase1;  // Phase-shifted clock 1
reg clk_div_phase2;  // Phase-shifted clock 2

// State machine to generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cycle_cnt <= 3'b000; // Reset counter
        state <= 2'b00;      // Reset state
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Initial state
                if (cycle_cnt == DIV_RATIO_1 - 1) begin
                    state <= 2'b01;
                    cycle_cnt <= 3'b000;
                    clk_div_int1 <= 1'b1;
                end else begin
                    cycle_cnt <= cycle_cnt + 1;
                    clk_div_int1 <= 1'b0;
                end
            end
            2'b01: begin // Second state
                if (cycle_cnt == DIV_RATIO_2 - 1) begin
                    state <= 2'b10;
                    cycle_cnt <= 3'b000;
                    clk_div_int2 <= 1'b1;
                end else begin
                    cycle_cnt <= cycle_cnt + 1;
                    clk_div_int2 <= 1'b0;
                end
            end
            2'b10: begin // Third state
                state <= 2'b00; // Reset state after completing a cycle
            end
            default: state <= 2'b00;
        endcase
    end
end

// Phase-shifting and combining clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Phase-shifting: Delay one clock by half a cycle, advance the other
        // For simplicity, we use the current and previous values of clk_div_int1 and clk_div_int2
        // to mimic the phase shift, considering the clock is divided into two parts.
        // The actual implementation might require a more sophisticated method for precise phase shifting.
        clk_div_phase1 <= clk_div_int1;
        clk_div_phase2 <= clk_div_int2;
        // Combine phase-shifted clocks
        clk_div <= clk_div_phase1 | clk_div_phase2;
    end
end

endmodule