module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE        = 2'b00, // waiting for initial 0
        WAIT_FOR_1  = 2'b01, // received 0, waiting for 1
        WAIT_FOR_0  = 2'b10  // received 0->1, waiting for final 0
    } state_t;

    state_t current_state, next_state;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state;

            // Output logic: assert data_out only at the cycle when the pulse completes
            data_out <= (current_state == WAIT_FOR_0 && data_in == 1'b0) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_1;
                else
                    next_state = IDLE;
            end
            WAIT_FOR_1: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_0;
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_1; // stay in this state if 0 continues
                else
                    next_state = IDLE; // fallback, though data_in is 1-bit
            end
            WAIT_FOR_0: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_1; // pulse detected, reset to wait for next
                else if (data_in == 1'b1)
                    next_state = IDLE; // invalid sequence, restart
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule