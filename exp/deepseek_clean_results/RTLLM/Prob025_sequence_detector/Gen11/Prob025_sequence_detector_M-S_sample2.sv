module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// States for the FSM
typedef enum logic [1:0] {
    IDLE,       // Waiting for first '1'
    GOT1,       // Received '1' (first bit)
    GOT10       // Received '10' (first two bits)
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Output is high only when we detect the complete pattern
        sequence_detected <= (current_state == GOT10) && data_in;
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: if (data_in) next_state = GOT1;
        GOT1: if (!data_in) next_state = GOT10;
        GOT10: begin
            if (data_in) next_state = IDLE;  // Pattern complete
            else next_state = IDLE;           // Pattern broken
        end
    endcase
end

endmodule