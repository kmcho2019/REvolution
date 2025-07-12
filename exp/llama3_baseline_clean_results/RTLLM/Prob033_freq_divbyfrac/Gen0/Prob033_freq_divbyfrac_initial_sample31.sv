module freq_divbyfrac(
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Parameters for the fractional division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division (3.5x division)
parameter LONG_CYCLE_CLK = 4; // Clock cycles for the longer period
parameter SHORT_CYCLE_CLK = 3; // Clock cycles for the shorter period

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg clk_int; // Intermediate divided clock
reg clk_shifted; // Phase-shifted version of the intermediate clock

// State machine states
enum logic [1:0] {
    IDLE,
    LONG_CYCLE,
    SHORT_CYCLE
} state, next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        IDLE: begin
            if(counter == 0) next_state = LONG_CYCLE;
            else next_state = IDLE;
        end
        LONG_CYCLE: begin
            if(counter == LONG_CYCLE_CLK) next_state = SHORT_CYCLE;
            else next_state = LONG_CYCLE;
        end
        SHORT_CYCLE: begin
            if(counter == SHORT_CYCLE_CLK) next_state = IDLE;
            else next_state = SHORT_CYCLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state and counter updates
always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        counter <= 0;
        clk_int <= 0;
        clk_shifted <= 0;
    end else begin
        state <= next_state;
        if(state == LONG_CYCLE) begin
            if(counter < LONG_CYCLE_CLK) counter <= counter + 1;
            else counter <= 0;
            clk_int <= (counter == LONG_CYCLE_CLK);
        end else if(state == SHORT_CYCLE) begin
            if(counter < SHORT_CYCLE_CLK) counter <= counter + 1;
            else counter <= 0;
            clk_int <= (counter == SHORT_CYCLE_CLK);
        end else begin
            counter <= 0;
            clk_int <= 0;
        end
        
        // Generate phase-shifted clock (delayed and advanced versions)
        clk_shifted <= clk_int;
        
        // Final fractional divided clock output
        // Using the phase-shifted clocks to achieve uniform period
        clk_div <= clk_int | clk_shifted;
    end
end

endmodule