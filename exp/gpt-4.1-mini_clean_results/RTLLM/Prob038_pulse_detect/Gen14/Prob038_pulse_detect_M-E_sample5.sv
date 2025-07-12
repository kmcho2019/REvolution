module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,    // Waiting for rising edge
        WAIT_FALL = 2'b01  // Waiting for falling edge after rising detected
    } state_t;

    state_t state, next_state;

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default data_out deassert
            data_out <= 1'b0;

            // Assert data_out only when pulse completed (i.e. falling edge detected after rising)
            if (state == WAIT_FALL && data_in == 1'b0) begin
                // Pulse detected (0->1->0 pattern)
                data_out <= 1'b1;
            end
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FALL;
                else
                    next_state = IDLE;
            end
            WAIT_FALL: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = WAIT_FALL;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule