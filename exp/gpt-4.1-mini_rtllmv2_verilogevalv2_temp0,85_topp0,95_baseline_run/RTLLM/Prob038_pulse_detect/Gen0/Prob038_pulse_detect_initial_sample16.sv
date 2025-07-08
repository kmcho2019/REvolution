module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum reg [1:0] {
        S_IDLE = 2'd0,     // waiting for first '0'
        S_HIGH = 2'd1,     // detected rising edge: saw '1'
        S_PULSE_END = 2'd2 // detected falling edge to '0' after '1', pulse end
    } state_t;

    reg [1:0] state, next_state;

    // FSM next state logic
    always @(*) begin
        case(state)
            S_IDLE: begin
                if (data_in == 1'b1)
                    next_state = S_HIGH;
                else
                    next_state = S_IDLE;
            end
            S_HIGH: begin
                if (data_in == 1'b0)
                    next_state = S_PULSE_END;
                else
                    next_state = S_HIGH;
            end
            S_PULSE_END: begin
                // After pulse is detected, go back to IDLE and wait for next pulse
                if (data_in == 1'b1)
                    next_state = S_HIGH;
                else
                    next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // FSM state transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= S_IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only on the cycle when pulse ends (S_PULSE_END state)
            data_out <= (state == S_PULSE_END) ? 1'b1 : 1'b0;
        end
    end

endmodule