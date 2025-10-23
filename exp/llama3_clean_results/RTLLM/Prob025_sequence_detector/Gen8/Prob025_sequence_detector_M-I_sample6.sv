module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3
} state, next_state;

// Current state register
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE; // Reset sequence detection upon mismatch
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = IDLE; // Sequence detected, reset to IDLE
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE; // Reset sequence detection upon mismatch
                sequence_detected = 1'b0;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Assign output based on the final state
always @(*) begin
    if (state == S3 && data_in == 1'b1) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule