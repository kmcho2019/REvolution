module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // Waiting for 0
        WAIT_1 = 2'b01, // Detected 0, waiting for 1
        WAIT_0 = 2'b10  // Detected 0->1, waiting for 0 to complete pulse
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default output
            data_out <= 1'b0;

            if (state == WAIT_0 && data_in == 1'b0) begin
                // Pulse detected at this cycle
                data_out <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_1; // Wait for rising edge
                else
                    next_state = IDLE;
            end
            WAIT_1: begin
                if (data_in == 1'b1)
                    next_state = WAIT_0; // Rising edge detected, wait for falling edge
                else if (data_in == 1'b0)
                    next_state = WAIT_1; // Still waiting for 1
                else
                    next_state = IDLE;
            end
            WAIT_0: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // Falling edge detected, pulse ended
                else
                    next_state = WAIT_0; // Still waiting for 0
            end
            default: next_state = IDLE;
        endcase
    end

endmodule