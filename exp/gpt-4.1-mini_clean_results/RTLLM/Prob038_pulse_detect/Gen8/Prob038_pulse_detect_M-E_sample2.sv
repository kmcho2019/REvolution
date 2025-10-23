module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_ONE    = 2'b01,
        WAIT_ZERO   = 2'b10,
        PULSE_DETECTED = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_ONE;
                else
                    next_state = IDLE;
            end

            WAIT_ONE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_ZERO;
                else if (data_in == 1'b0)
                    next_state = WAIT_ONE; // Stay waiting for 1
                else
                    next_state = IDLE; // Should not occur for 1-bit input
            end

            WAIT_ZERO: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else if (data_in == 1'b1)
                    next_state = WAIT_ZERO; // Stay waiting for 0
                else
                    next_state = IDLE;
            end

            PULSE_DETECTED: begin
                next_state = IDLE; // After asserting pulse, return to IDLE
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state update and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == PULSE_DETECTED)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule