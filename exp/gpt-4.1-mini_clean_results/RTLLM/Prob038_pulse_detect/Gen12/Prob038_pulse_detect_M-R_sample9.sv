module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding (4 states)
    typedef enum logic [1:0] {
        IDLE       = 2'd0, // Waiting for pulse start (data_in=0)
        HIGH       = 2'd1, // Detected rising edge (data_in=1)
        LOW_DETECT = 2'd2, // Detected falling edge after high (data_in=0)
        PULSE_END  = 2'd3  // Pulse detected, output asserted
    } state_t;

    state_t state, next_state;

    // Sequential state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Output asserted for one cycle in PULSE_END state
            if (next_state == PULSE_END)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (!data_in)
                    next_state = LOW_DETECT;
                else
                    next_state = HIGH;
            end
            LOW_DETECT: begin
                if (data_in)
                    next_state = HIGH;   // Possibly next pulse start
                else
                    next_state = PULSE_END;
            end
            PULSE_END: begin
                // After output pulse, wait for new pulse (data_in must be low)
                if (!data_in)
                    next_state = IDLE;
                else
                    next_state = HIGH; // If still high, re-enter HIGH state
            end
            default: next_state = IDLE;
        endcase
    end

endmodule