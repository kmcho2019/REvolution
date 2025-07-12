module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for the fractional frequency division
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4; // Number of clock cycles for the high phase
parameter DIV_CLK_LOW = 3; // Number of clock cycles for the low phase

// Define the state machine states
enum logic [1:0] {IDLE, HIGH_PHASE, LOW_PHASE} state, next_state;

// Define the clock cycle counter
reg [2:0] counter;

// Define the intermediate divided clock signals
reg clk_div_high;
reg clk_div_low;

// Define the phase-shifted versions of the divided clock
reg clk_div_high_shifted;
reg clk_div_low_shifted;

always @(*) begin
    // Default values for the next state and counter
    next_state = state;
    counter = counter;

    // State machine logic
    case (state)
        IDLE: begin
            if (rst_n == 1'b0) begin
                next_state = IDLE;
                counter = 3'b000;
            end else if (counter == MUL2_DIV_CLK - 1) begin
                next_state = HIGH_PHASE;
                counter = 3'b000;
            end else begin
                next_state = IDLE;
                counter = counter + 1'b1;
            end
        end
        HIGH_PHASE: begin
            if (rst_n == 1'b0) begin
                next_state = IDLE;
                counter = 3'b000;
            end else if (counter == DIV_CLK_HIGH - 1) begin
                next_state = LOW_PHASE;
                counter = 3'b000;
            end else begin
                next_state = HIGH_PHASE;
                counter = counter + 1'b1;
            end
        end
        LOW_PHASE: begin
            if (rst_n == 1'b0) begin
                next_state = IDLE;
                counter = 3'b000;
            end else if (counter == DIV_CLK_LOW - 1) begin
                next_state = HIGH_PHASE;
                counter = 3'b000;
            end else begin
                next_state = LOW_PHASE;
                counter = counter + 1'b1;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        state <= IDLE;
        clk_div_high <= 1'b0;
        clk_div_low <= 1'b0;
        clk_div_high_shifted <= 1'b0;
        clk_div_low_shifted <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            HIGH_PHASE: begin
                if (counter == 0) begin
                    clk_div_high <= 1'b1;
                end else if (counter == DIV_CLK_HIGH - 1) begin
                    clk_div_high <= 1'b0;
                end
            end
            LOW_PHASE: begin
                if (counter == 0) begin
                    clk_div_low <= 1'b1;
                end else if (counter == DIV_CLK_LOW - 1) begin
                    clk_div_low <= 1'b0;
                end
            end
        endcase
        // Generate phase-shifted versions of the divided clock
        clk_div_high_shifted <= clk_div_high && !clk_div_low;
        clk_div_low_shifted <= !clk_div_high && clk_div_low;
        // Generate the final fractional divided clock output
        clk_div <= clk_div_high || clk_div_low || clk_div_high_shifted || clk_div_low_shifted;
    end
end

endmodule