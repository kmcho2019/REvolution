module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for detecting the sequence 1101
enum logic [1:0] {
    IDLE = 2'b00,
    SEEN_1 = 2'b01,
    SEEN_11 = 2'b10,
    SEEN_110 = 2'b11,
    DETECTED = 2'b00 // Corrected enum definition to avoid conflict
} state, next_state;

// However, since we need a distinct value for DETECTED, we should not reuse any existing state's value.
// A better approach would be to extend the enum size to accommodate all states uniquely.

// Revising the enum definition to accommodate all states uniquely:
enum logic [2:0] {
    IDLE = 3'b000,
    SEEN_1 = 3'b001,
    SEEN_11 = 3'b010,
    SEEN_110 = 3'b011,
    SEEN_1101 = 3'b100, // DETECTED state renamed for clarity and assigned a unique value
    DEFAULT_STATE = 3'b111 // An additional state for default, ensuring all possible values are covered
} state, next_state;

// Current state and next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == SEEN_1101) begin // Set start_shifting when sequence is detected
            start_shifting <= 1'b1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (data == 1'b1) begin
                next_state = SEEN_11;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_11: begin
            if (data == 1'b0) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data == 1'b1) begin
                next_state = SEEN_1101;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1101: begin
            next_state = SEEN_1101; // Stay in detected state
        end
        default: next_state = IDLE;
    endcase
end

endmodule