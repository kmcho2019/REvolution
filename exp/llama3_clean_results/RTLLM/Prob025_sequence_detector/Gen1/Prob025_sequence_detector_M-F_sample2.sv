module sequence_detector(
    input clk,
    input reset_n, // This port name should match the one used in the testbench
    input data_in,
    output reg sequence_detected // Declare sequence_detected as reg for clarity and synthesis purposes
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    S1   = 3'b010,
    S2   = 3'b011,
    S3   = 3'b100,
    S4   = 3'b101
} state, next_state;

// Assign the output sequence_detected based on the state
always @(*) begin // Use always @(*) for combinational logic
    if (state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

// Define the FSM transition logic
always_comb begin
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
                next_state = IDLE; // Reset to IDLE if sequence is not matched
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3; // Progress to S3 upon seeing '0'
            end else begin
                next_state = IDLE; // Incorrect sequence, reset
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE; // Sequence not matched, reset
            end
        end
        S4: begin
            next_state = IDLE; // Upon detecting the sequence, reset to IDLE
        end
        default: next_state = IDLE;
    endcase
end

// Define the sequential logic for the state register
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule