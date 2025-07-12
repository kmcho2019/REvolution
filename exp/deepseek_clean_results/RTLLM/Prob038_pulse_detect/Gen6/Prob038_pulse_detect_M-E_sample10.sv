module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_01,
    PULSE
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is only high when in PULSE state
        data_out <= (next_state == PULSE);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        
        GOT_0: begin
            if (data_in == 1'b1)
                next_state = GOT_01;
            else
                next_state = GOT_0;  // Stay in GOT_0 if we get another 0
        end
        
        GOT_01: begin
            if (data_in == 1'b0)
                next_state = PULSE;
            else
                next_state = IDLE;   // Reset if we get another 1
        end
        
        PULSE: begin
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule