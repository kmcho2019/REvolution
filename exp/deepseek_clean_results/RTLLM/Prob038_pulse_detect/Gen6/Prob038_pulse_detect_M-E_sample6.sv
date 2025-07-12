module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

typedef enum {
    IDLE,       // Waiting for first 0
    FIRST_1,    // Received first 1 (after 0)
    SECOND_0,   // Received second 0 (after 1)
    DETECT      // Pulse detected
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        current_state <= next_state;
        
        // Output is only high when in DETECT state
        data_out <= (next_state == DETECT);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = FIRST_1;
            else
                next_state = IDLE;
        end
        
        FIRST_1: begin
            if (data_in == 1'b1)
                next_state = SECOND_0;
            else
                next_state = FIRST_1; // Stay until we see 1
        end
        
        SECOND_0: begin
            if (data_in == 1'b0)
                next_state = DETECT;
            else
                next_state = IDLE; // Sequence broken
        end
        
        DETECT: begin
            next_state = IDLE; // Always return to idle after detection
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule