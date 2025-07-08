module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RISING = 2'b01,
        HIGH = 2'b10,
        PULSE_END = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        // Default next state
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = RISING;  // Confirm 0 to start pulse
                else
                    next_state = IDLE;
            end
            RISING: begin
                if (data_in == 1'b1)
                    next_state = HIGH;    // 0->1 detected
                else if (data_in == 1'b0)
                    next_state = RISING;  // stay waiting for rising edge
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;  // 1->0 completed pulse
                else
                    next_state = HIGH;       // stay waiting for falling edge
            end
            PULSE_END: begin
                // After pulse is detected, immediately go to IDLE to detect next pulse
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output and state update logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == PULSE_END)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule