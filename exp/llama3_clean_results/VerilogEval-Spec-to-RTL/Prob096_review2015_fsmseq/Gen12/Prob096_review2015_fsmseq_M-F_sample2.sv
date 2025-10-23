module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the sequence 1101
enum logic [2:0] {
    IDLE = 3'b000,
    SEEN_1 = 3'b001,
    SEEN_11 = 3'b010,
    SEEN_110 = 3'b011,
    SEQUENCE_DETECTED = 3'b100
} state, next_state;

// Current state and next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
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
                next_state = SEQUENCE_DETECTED;
            end else begin
                next_state = IDLE;
            end
        end
        SEQUENCE_DETECTED: begin
            next_state = SEQUENCE_DETECTED;
        end
        default: next_state = IDLE;
    endcase
end

// Set start_shifting based on state
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0;
    end else if (state == SEQUENCE_DETECTED) begin
        start_shifting <= 1'b1;
    end
end

endmodule