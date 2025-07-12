module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Register to store the incoming data
logic [3:0] shift_reg;

// Counter for shifting
logic [1:0] shift_cnt;

// Default values for outputs
assign shift_ena = 1'b0;
assign counting = 1'b0;
assign done = 1'b0;

// State machine logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'b0;
        shift_cnt <= 2'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Shift in the incoming data
                shift_reg <= {shift_reg[2:0], data};
                // Check if the pattern 1101 is detected
                if (shift_reg == 4'b1101) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                // Assert shift_ena for exactly 4 clock cycles
                shift_ena <= 1'b1;
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 2'b100) begin
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                // Assert counting to indicate waiting for the counters
                counting <= 1'b1;
                // Wait until done_counting is high
                if (done_counting) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                // Assert done to notify the user
                done <= 1'b1;
                // Wait until ack is 1
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

endmodule