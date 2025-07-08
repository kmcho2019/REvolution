module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        WAIT_HIGH = 2'b01,
        WAIT_FALL = 2'b10
    } state_t;
    
    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default output 0 unless pulse detected
            if (state == WAIT_FALL && data_in == 1'b0)
                data_out <= 1'b1;  // pulse end detected
            else
                data_out <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FALL; // direct jump to wait fall because we saw a high without seeing 0->1->0 but to handle possible input glitches, let's implement as per problem:
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // wait for rising edge
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FALL; // rising edge detected
                else
                    next_state = WAIT_HIGH; // stay waiting for rising edge
            end
            WAIT_FALL: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // pulse ended, go back to wait for next rising edge
                else
                    next_state = WAIT_FALL; // wait for falling edge
            end
            default: next_state = IDLE;
        endcase
    end

endmodule