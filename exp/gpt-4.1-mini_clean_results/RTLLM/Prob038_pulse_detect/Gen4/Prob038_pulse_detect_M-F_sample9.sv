module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding for clarity
    typedef enum logic [1:0] {
        WAIT_FOR_FIRST_ZERO  = 2'b00, // Waiting for the first 0 in pulse
        WAIT_FOR_ONE         = 2'b01, // After first 0 detected, waiting for 1
        WAIT_FOR_SECOND_ZERO = 2'b10  // After 1 detected, waiting for second 0 to complete pulse
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_FIRST_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE;
                else
                    next_state = WAIT_FOR_FIRST_ZERO;
            end
            WAIT_FOR_ONE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_SECOND_ZERO;
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE; // still waiting for 1
                else
                    next_state = WAIT_FOR_FIRST_ZERO; // fallback, not expected here
            end
            WAIT_FOR_SECOND_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_FIRST_ZERO; // pulse complete, restart detection
                else if (data_in == 1'b1)
                    next_state = WAIT_FOR_SECOND_ZERO; // wait for second zero
                else
                    next_state = WAIT_FOR_FIRST_ZERO; // fallback
            end
            default: next_state = WAIT_FOR_FIRST_ZERO;
        endcase
    end

    // Sequential logic for state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= WAIT_FOR_FIRST_ZERO;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Assert data_out for one cycle when pulse completes:
            // When in WAIT_FOR_SECOND_ZERO state and data_in==0, the pulse ended
            data_out <= (state == WAIT_FOR_SECOND_ZERO && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule