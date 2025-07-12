module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states
    typedef enum logic [1:0] {
        IDLE    = 2'b00, // Waiting for 0 to start pulse detection
        GOT_ZERO= 2'b01, // Detected initial 0
        GOT_ONE = 2'b10  // Detected 1 after 0, waiting for trailing 0
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        data_out = 1'b0;

        case(state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = GOT_ZERO;
                else
                    next_state = IDLE;
            end
            GOT_ZERO: begin
                if (data_in == 1'b1)
                    next_state = GOT_ONE;
                else if (data_in == 1'b0)
                    next_state = GOT_ZERO; // Stay in GOT_ZERO if still zero
                else
                    next_state = IDLE;     // Defensive fallback
            end
            GOT_ONE: begin
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                    data_out = 1'b1; // Pulse detected at end of pattern 0->1->0
                end else if (data_in == 1'b1) begin
                    next_state = GOT_ONE; // Still in GOT_ONE state waiting for zero
                end else begin
                    next_state = IDLE;     // Defensive fallback
                end
            end
            default: begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        endcase
    end

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule