module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_01,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 0;
    end else begin
        current_state <= next_state;
        
        // Output is high only when we complete the 010 sequence
        data_out <= (next_state == PULSE_DETECTED);
    end
end

always @(*) begin
    // Default next state
    next_state = current_state;
    
    case (current_state)
        IDLE: begin
            if (data_in == 0)
                next_state = GOT_0;
        end
        
        GOT_0: begin
            if (data_in == 1)
                next_state = GOT_01;
            else if (data_in == 0)
                next_state = GOT_0;  // Stay in GOT_0 if we get consecutive 0s
        end
        
        GOT_01: begin
            if (data_in == 0)
                next_state = PULSE_DETECTED;
            else
                next_state = IDLE;  // Reset if we get 011 pattern
        end
        
        PULSE_DETECTED: begin
            // After detecting pulse, check if we have a new 0
            next_state = (data_in == 0) ? GOT_0 : IDLE;
        end
    endcase
end

endmodule