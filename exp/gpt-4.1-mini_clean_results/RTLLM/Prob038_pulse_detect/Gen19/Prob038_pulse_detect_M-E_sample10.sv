module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states of FSM
    typedef enum logic [1:0] {
        IDLE      = 2'b00,  // waiting for initial 0
        WAIT_HIGH = 2'b01,  // got 0, waiting for 1
        WAIT_LOW  = 2'b10   // got 0 then 1, waiting for 0 again
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        data_out = 1'b0;
        case (current_state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end
            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // stay, still waiting for 1
                else
                    next_state = IDLE; // default back to IDLE
            end
            WAIT_LOW: begin
                if (data_in == 1'b0) begin
                    data_out = 1'b1; // pulse detected here
                    next_state = WAIT_HIGH; // can detect overlapping pulses
                end else if (data_in == 1'b1) begin
                    next_state = WAIT_LOW; // still waiting for low 0
                end else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic to update state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state;
            // data_out is assigned combinationally above, so no need to reassign here.
            // However, to make data_out register, we assign it here as well:
            data_out <= data_out;
        end
    end

endmodule