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
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Next state logic and output assignment
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
                sequence_detected = 1'b0;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
                sequence_detected = 1'b0;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
                sequence_detected = 1'b0;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            sequence_detected = 1'b0;
        end
    endcase
end

endmodule