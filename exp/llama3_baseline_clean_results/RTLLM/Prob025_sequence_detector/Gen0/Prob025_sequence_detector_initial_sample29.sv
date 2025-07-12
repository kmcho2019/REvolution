module sequence_detector(
    input clk,        // Clock signal
    input reset_n,    // Reset signal
    input data_in,    // 1-bit binary input signal
    output reg sequence_detected  // 1-bit output signal
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_type;

// Declare the current and next states
state_type current_state, next_state;

// Initialize the sequence_detected signal
always @(posedge clk) begin
    if (!reset_n) begin
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= (current_state == S4) ? 1'b1 : 1'b0;
    end
end

// Define the state transitions
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = IDLE;
            end else if (data_in == 1'b0) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else if (data_in == 1'b1) begin
                next_state = S3;
            end else begin
                next_state = S2;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = IDLE;
            end else if (data_in == 1'b0) begin
                next_state = S4;
            end else begin
                next_state = S3;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update the current state
always @(posedge clk) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule