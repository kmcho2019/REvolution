module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the FSM
typedef enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3
} state_t;

// Current state and next state
state_t current_state, next_state;

// Output signal
assign sequence_detected = (current_state == S3) && data_in;

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
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
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = S3;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule