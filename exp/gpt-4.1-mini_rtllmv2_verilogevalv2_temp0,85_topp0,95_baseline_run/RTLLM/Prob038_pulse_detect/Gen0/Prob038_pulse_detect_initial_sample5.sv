module pulse_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE          = 2'b00, // Waiting for first rising edge (0->1)
        HIGH_DETECTED = 2'b01, // Detected '1' after 0, waiting for final 0
        PULSE_END     = 2'b10  // Pulse detected (0->1->0), data_out=1 this cycle
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is only asserted in PULSE_END state, else 0
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for data_in to go from 0 to 1 to start pulse detection
                if (data_in == 1'b0)
                    next_state = IDLE;
                else // data_in == 1
                    next_state = HIGH_DETECTED;
            end

            HIGH_DETECTED: begin
                // Wait for data_in to go back to 0 to complete pulse
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    next_state = HIGH_DETECTED;
            end

            PULSE_END: begin
                // After pulse detected, wait for data_in == 1 or 0 to restart detection
                if (data_in == 1'b0)
                    next_state = IDLE;          // pulse ended, back to IDLE
                else
                    next_state = HIGH_DETECTED; // maybe start of new pulse
            end

            default: next_state = IDLE;
        endcase
    end

endmodule