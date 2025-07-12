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

    // Next state logic - combinational
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
                else
                    next_state = WAIT_FOR_HIGH;  // Stay waiting for high, allowing multiple 0's
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;  // Pulse detected: 0->1->0
                else
                    next_state = WAIT_FOR_LOW;    // Stay waiting for 0 to complete pulse
            end

            PULSE_DETECTED: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State and output register update - synchronous
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output 1 only in PULSE_DETECTED state
            if (next_state == PULSE_DETECTED)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule