module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE      = 2'b00,
        HIGH      = 2'b01,
        PULSE_END = 2'b10
    } state_t;

    state_t state, next_state;

    // Sequential state and output update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state    <= next_state;
            // data_out asserted only in PULSE_END state
            data_out <= (next_state == PULSE_END) ? 1'b1 : 1'b0;
        end
    end

    // Combinational next state logic
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
                else if (data_in == 1'b1)
                    next_state = HIGH;  // Stay in HIGH if still 1, waiting for next falling edge
                else
                    next_state = IDLE;   // Default fallback (should never reach)
            end

            PULSE_END: begin
                // After pulse detected, wait for next pulse start
                if (data_in == 1'b1)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule