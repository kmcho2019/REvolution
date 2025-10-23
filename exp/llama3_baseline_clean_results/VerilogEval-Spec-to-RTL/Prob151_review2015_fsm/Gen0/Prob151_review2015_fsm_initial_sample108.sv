module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
typedef enum {
    IDLE,
    SHIFT,
    COUNT,
    DONE_STATE,
    RESET_STATE
} state_t;

// State register
state_t state, next_state;

// Counter to keep track of the number of bits shifted
reg [1:0] shift_counter;

// Output signals
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

// Pattern detector
reg [3:0] pattern_reg;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_counter <= 0;
        pattern_reg <= 0;
    end else begin
        state <= next_state;
        shift_ena_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;

        case (state)
            IDLE: begin
                pattern_reg <= {data, pattern_reg[3:1]};
                if (pattern_reg == 4'b1101) begin
                    next_state <= SHIFT;
                    shift_counter <= 0;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena_reg <= 1;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                counting_reg <= 1;
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE_STATE: begin
                done_reg <= 1;
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE_STATE;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

// Continuous assignments for outputs
assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule