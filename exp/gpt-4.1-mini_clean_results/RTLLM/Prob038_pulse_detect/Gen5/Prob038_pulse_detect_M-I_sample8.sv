module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_FOR_FIRST_ZERO  = 2'b00,
        WAIT_FOR_ONE         = 2'b01,
        WAIT_FOR_SECOND_ZERO = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_FIRST_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE;
                else
                    next_state = WAIT_FOR_FIRST_ZERO;
            end

            WAIT_FOR_ONE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_SECOND_ZERO;
                else // data_in == 0
                    next_state = WAIT_FOR_FIRST_ZERO; // restart, since no '1' observed
            end

            WAIT_FOR_SECOND_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_FIRST_ZERO; // pulse complete, restart
                else // data_in == 1
                    next_state = WAIT_FOR_SECOND_ZERO; // keep waiting for zero to complete pulse
            end

            default: next_state = WAIT_FOR_FIRST_ZERO;
        endcase
    end

    // Sequential logic: state update and pulse output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= WAIT_FOR_FIRST_ZERO;
            data_out <= 1'b0;
        end else begin
            // Pulse detected when next_state transitions back to WAIT_FOR_FIRST_ZERO from WAIT_FOR_SECOND_ZERO due to data_in == 0
            // This means current state is WAIT_FOR_SECOND_ZERO and data_in == 0, so pulse ends this cycle
            data_out <= (state == WAIT_FOR_SECOND_ZERO && data_in == 1'b0) ? 1'b1 : 1'b0;
            state <= next_state;
        end
    end

endmodule