module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

state_t current_state;
state_t next_state;

always @(*) begin
    // IDLE state: wait for the start of the sequence
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end

        // S1 state: first bit of the sequence detected
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end

        // S2 state: second bit of the sequence detected
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end

        // S3 state: third bit of the sequence detected
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end

        // S4 state: fourth bit of the sequence detected
        S4: begin
            next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the state machine
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        // Update the current state
        current_state <= next_state;
        
        // Assert sequence_detected when the sequence is detected
        if (current_state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule