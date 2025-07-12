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
    DETECTED = 2'b10 // Reuse SEEN_11 for detected state to minimize state definitions
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
                next_state = DETECTED;
                start_shifting = 1'b1; // Set start_shifting when sequence is detected
            end else begin
                next_state = IDLE;
            end
        end
        DETECTED: begin
            next_state = DETECTED; // Stay in detected state
        end
        default: next_state = IDLE;
    endcase
end

endmodule