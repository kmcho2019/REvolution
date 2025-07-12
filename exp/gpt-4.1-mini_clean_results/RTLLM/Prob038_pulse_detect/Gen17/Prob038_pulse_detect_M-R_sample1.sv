module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE,       // waiting for data_in to go high
        WAIT_FALL,  // waiting for data_in to fall back to 0
        PULSE_END   // pulse detected, output data_out=1 for one cycle
    } state_t;

    state_t state, next_state;

    reg data_in_d; // previous cycle data_in

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_in_d <= 1'b0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_in_d <= data_in;

            if (next_state == PULSE_END)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect rising edge: previous 0, current 1
                if (data_in_d == 1'b0 && data_in == 1'b1)
                    next_state = WAIT_FALL;
            end
            WAIT_FALL: begin
                // Detect falling edge: previous 1, current 0
                if (data_in_d == 1'b1 && data_in == 1'b0)
                    next_state = PULSE_END;
            end
            PULSE_END: begin
                // Output pulse end for one cycle, then return to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule