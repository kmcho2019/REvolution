module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE          = 2'b00,
        WAIT_FOR_HIGH = 2'b01,
        WAIT_FOR_LOW  = 2'b10,
        PULSE_DETECTED= 2'b11
    } state_t;

    state_t state, next_state;

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        data_out = 1'b0;

        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_FOR_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH;  // Stay waiting for high, allowing multiple 0's
                else
                    next_state = IDLE;
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0) begin
                    next_state = PULSE_DETECTED;  // Pulse detected: 0->1->0
                end else if (data_in == 1'b1) begin
                    // If another 1, remain in WAIT_FOR_LOW, waiting for 0 to complete pulse
                    next_state = WAIT_FOR_LOW;
                end else begin
                    next_state = IDLE;
                end
            end

            PULSE_DETECTED: begin
                data_out = 1'b1;  // Indicate pulse detection at last cycle of pulse
                next_state = IDLE; // Go back to start for new pulses
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule