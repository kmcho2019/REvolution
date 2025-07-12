module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE     = 2'd0,
        HIGH     = 2'd1,
        LOW_WAIT = 2'd2
    } state_t;

    reg data_in_dly;       // Delayed input for edge detection
    reg state_t state, next_state;

    // State transition combinational logic
    always @(*) begin
        next_state = state;     // Default hold state
        case (state)
            IDLE: begin
                if (~data_in_dly & data_in)       // Rising edge detected
                    next_state = HIGH;
            end
            HIGH: begin
                if (data_in_dly & ~data_in)       // Falling edge detected
                    next_state = LOW_WAIT;
                else if (~data_in)                 // Data_in dropped before expected pulse, reset
                    next_state = IDLE;
            end
            LOW_WAIT: begin
                // After detecting falling edge (pulse complete), move to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, data_in_dly, and data_out
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state       <= IDLE;
            data_in_dly <= 1'b0;
            data_out    <= 1'b0;
        end else begin
            data_in_dly <= data_in;
            state       <= next_state;

            // Assert data_out only at the cycle pulse completes (LOW_WAIT state)
            data_out <= (next_state == LOW_WAIT) ? 1'b1 : 1'b0;
        end
    end

endmodule