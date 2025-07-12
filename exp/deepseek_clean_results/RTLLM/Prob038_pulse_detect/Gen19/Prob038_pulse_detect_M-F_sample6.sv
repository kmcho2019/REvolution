module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,           // Waiting for first 0
    GOT_0,          // Received first 0, waiting for 1
    GOT_1,          // Received 1 after 0, waiting for final 0
    PULSE_DETECTED  // Pulse detected, output high for one cycle
} state_t;

// State registers
state_t current_state, next_state;

// Sequential state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Output is high only in PULSE_DETECTED state
        data_out <= (next_state == PULSE_DETECTED);
    end
end

// Combinational next state logic
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
                next_state = GOT_1;
            else
                next_state = GOT_0;  // Stay if consecutive 0s
        end
        GOT_1: begin
            if (data_in == 1'b0)
                next_state = PULSE_DETECTED;
            else
                next_state = IDLE;  // Reset if consecutive 1s
        end
        PULSE_DETECTED: begin
            // Immediately check for new pulse
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule