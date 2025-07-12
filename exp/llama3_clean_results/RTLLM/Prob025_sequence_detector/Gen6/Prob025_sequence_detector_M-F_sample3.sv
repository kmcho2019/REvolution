module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection with sufficient bits to represent all states
typedef enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t state, next_state;

// Update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Determine the next state using assign statements
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~data_in) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~data_in) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
            sequence_detected = 1'b1;
        end
        default: next_state = IDLE;
    endcase
end

// Assign the sequence_detected output
always_comb begin
    if (state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule