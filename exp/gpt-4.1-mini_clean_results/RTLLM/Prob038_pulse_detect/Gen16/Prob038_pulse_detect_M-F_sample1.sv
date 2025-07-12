module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_FALL   = 2'b01,
        PULSE_DETECTED = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FALL;
                else
                    next_state = IDLE;
            end
            WAIT_FALL: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else if (data_in == 1'b1)
                    next_state = WAIT_FALL;  // wait until falling edge
                else
                    next_state = IDLE; // safe default
            end
            PULSE_DETECTED: begin
                next_state = IDLE; // one cycle pulse output
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == PULSE_DETECTED)
                data_out <= 1'b1; // pulse detected, output high for one cycle
            else
                data_out <= 1'b0;
        end
    end

endmodule