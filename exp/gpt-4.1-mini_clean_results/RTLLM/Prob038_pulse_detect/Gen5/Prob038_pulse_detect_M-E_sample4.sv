module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE         = 2'b00,
        HIGH_DETECTED= 2'b01,
        PULSE_DETECTED= 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end
            HIGH_DETECTED: begin
                if (~data_in)
                    next_state = PULSE_DETECTED;
                else
                    next_state = HIGH_DETECTED;
            end
            PULSE_DETECTED: begin
                // After pulse output, return to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out = 1 only in PULSE_DETECTED state
            data_out <= (next_state == PULSE_DETECTED) ? 1'b1 : 1'b0;
        end
    end

endmodule