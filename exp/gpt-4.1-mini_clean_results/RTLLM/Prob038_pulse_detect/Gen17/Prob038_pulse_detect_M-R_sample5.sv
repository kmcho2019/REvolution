module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE      = 2'b00, // waiting for data_in=1
        HIGH      = 2'b01, // data_in=1 detected, waiting for falling edge
        PULSE_END = 2'b10  // pulse detected, output data_out=1 one cycle
    } state_t;

    state_t state, next_state;

    // State and output register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            // Output high only in PULSE_END state
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    next_state = HIGH;
            end

            PULSE_END: begin
                // After signaling the pulse, go back to IDLE to detect next pulse
                if (data_in == 1'b1)
                    next_state = HIGH; // immediately start next pulse
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule