module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define the states
enum logic [2:0] {
    IDLE,
    DETECTED_1,
    DETECTED_11,
    DETECTED_110,
    DETECTED_1101
} state, next_state;

// Assign start_shifting based on the current state
assign start_shifting = (state == DETECTED_1101);

// Finite-state machine logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state = DETECTED_1;
            end
        end
        DETECTED_1: begin
            if (data == 1) begin
                next_state = DETECTED_11;
            end else if (data == 0) begin
                next_state = IDLE;
            end
        end
        DETECTED_11: begin
            if (data == 0) begin
                next_state = DETECTED_110;
            end else if (data == 1) begin
                next_state = DETECTED_11;
            end
        end
        DETECTED_110: begin
            if (data == 1) begin
                next_state = DETECTED_1101;
            end else if (data == 0) begin
                next_state = IDLE;
            end
        end
        DETECTED_1101: begin
            // Stay in this state forever until reset
            next_state = DETECTED_1101;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule