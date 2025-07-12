module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize the current state
state_t current_state;

// Assign the initial value of sequence_detected to 0
initial sequence_detected = 0;

// Main FSM logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the FSM to the IDLE state
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Assert the sequence_detected signal
                sequence_detected <= 1'b1;
                current_state <= IDLE;
            end
        endcase
    end
end

// Reset sequence_detected when the FSM is not in the S4 state
always @(posedge clk) begin
    if (current_state!= S4) begin
        sequence_detected <= 0;
    end
end

endmodule