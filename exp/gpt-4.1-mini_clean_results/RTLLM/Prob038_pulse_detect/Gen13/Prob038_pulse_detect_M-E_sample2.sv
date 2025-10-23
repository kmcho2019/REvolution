module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE         = 2'b00,
        HIGH_DETECTED = 2'b01,
        LOW_DETECTED  = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic combinational block
    always @(*) begin
        // Default assignments
        next_state = state;
        data_out = 1'b0;

        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end

            HIGH_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = LOW_DETECTED;
                else
                    next_state = HIGH_DETECTED;
            end

            LOW_DETECTED: begin
                // Pulse detected at this cycle
                data_out = 1'b1;
                // Return to IDLE for next pulse detection
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;  // new pulse may start immediately
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out already assigned combinationally to produce one-cycle pulse in LOW_DETECTED state
        end
    end

endmodule