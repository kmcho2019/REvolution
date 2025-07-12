module sequence_detector (
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

// Declare the current state and next state
state_t current_state, next_state;

// Always block to handle the FSM
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the FSM to the IDLE state
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        // Update the current state based on the next state
        current_state <= next_state;
        
        // Reset sequence_detected
        sequence_detected <= 1'b0;
        
        // Determine the next state based on the current state and data_in
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state <= S1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    next_state <= S2;
                end else begin
                    next_state <= S1;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    next_state <= S3;
                end else begin
                    next_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state <= S4;
                end else begin
                    next_state <= IDLE;
                end
            end
            S4: begin
                // Set sequence_detected high when the sequence is detected
                sequence_detected <= 1'b1;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule