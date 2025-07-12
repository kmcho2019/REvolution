module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states for FSM
    typedef enum logic [1:0] {
        IDLE          = 2'b00,
        WAIT_FOR_HIGH = 2'b01,
        WAIT_FOR_LOW  = 2'b10,
        PULSE_DETECTED= 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
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
                    next_state = WAIT_FOR_HIGH; // still waiting for rising edge
                else
                    next_state = IDLE;
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW; // waiting for falling edge
                else
                    next_state = IDLE;
            end

            PULSE_DETECTED: begin
                // After pulse detected, restart waiting for next pulse
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted only in PULSE_DETECTED state for one cycle
            data_out <= (next_state == PULSE_DETECTED) ? 1'b1 : 1'b0;
        end
    end

endmodule