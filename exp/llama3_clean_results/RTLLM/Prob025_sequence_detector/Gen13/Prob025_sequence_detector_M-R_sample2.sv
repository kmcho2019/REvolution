module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,
    S2   = 2'b10,
    S3   = 2'b11
} state, next_state;

// Reset logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
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
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

// Assert the sequence_detected signal when the sequence is detected
always @(posedge clk) begin
    if (state == S3 && data_in == 1'b1) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule