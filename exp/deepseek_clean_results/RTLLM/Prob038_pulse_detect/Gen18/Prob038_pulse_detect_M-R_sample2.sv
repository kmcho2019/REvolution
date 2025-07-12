module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1,
    PULSE_DETECTED
} state_t;

// State registers
state_t current_state, next_state;

// Output assignment (combinational)
assign data_out = (current_state == PULSE_DETECTED);

// State transition logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Next state logic (combinational)
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
                next_state = GOT_0;  // Stay if we get consecutive 0s
        end
        GOT_1: begin
            if (data_in == 1'b0)
                next_state = PULSE_DETECTED;
            else
                next_state = IDLE;  // Reset if we get consecutive 1s
        end
        PULSE_DETECTED: begin
            next_state = IDLE;  // Always return to IDLE after detection
        end
        default: next_state = IDLE;
    endcase
end

endmodule