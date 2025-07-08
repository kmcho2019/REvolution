module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        WAIT_HIGH = 2'b01,
        WAIT_LOW  = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is set only when pulse is detected
            if (state == WAIT_LOW && data_in == 1'b0) begin
                data_out <= 1'b1;  // pulse detected at end of cycle
            end else begin
                data_out <= 1'b0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for data_in == 0 to start pulse detection
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                // Wait for data_in == 1
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // stay waiting if still 0
                else
                    next_state = IDLE; // fallback to IDLE
            end
            WAIT_LOW: begin
                // Wait for data_in == 0 to complete pulse
                if (data_in == 1'b0)
                    next_state = IDLE; // pulse done, back to IDLE
                else
                    next_state = WAIT_LOW; // keep waiting if still 1
            end
            default: next_state = IDLE;
        endcase
    end

endmodule