module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding using one-hot (could also use binary for smaller area)
typedef enum logic [1:0] {
    IDLE = 2'b00,
    S1   = 2'b01,   // Received '1'
    S2   = 2'b10,   // Received '10'
    S3   = 2'b11    // Received '100'
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    next_state = current_state;
    sequence_detected = 1'b0;
    
    case (current_state)
        IDLE: 
            if (data_in) next_state = S1;
        S1:
            if (~data_in) next_state = S2;
            else next_state = S1;  // Stay if we get another '1'
        S2:
            if (~data_in) next_state = S3;
            else next_state = IDLE; // Reset if we get '1' after '10'
        S3:
            if (data_in) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end
            else next_state = IDLE; // Reset if we get '0' after '100'
    endcase
end

// State register update with clock gating
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end
    else if (next_state != current_state) begin  // Only update if state changes
        current_state <= next_state;
    end
end

endmodule