module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00, // waiting for data_in=0 (initial)
        RISE      = 2'b01, // waiting for data_in=1 (rising edge detected)
        FALL      = 2'b10  // waiting for data_in=0 (falling edge detected)
    } state_t;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = RISE; // expecting 1 next
                else
                    next_state = IDLE;
            end
            RISE: begin
                if (data_in == 1'b1)
                    next_state = FALL; // expecting 0 next
                else if (data_in == 1'b0)
                    next_state = RISE; // still waiting for rising edge
                else
                    next_state = IDLE; // fail-safe fallback
            end
            FALL: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // pulse ended, go back to IDLE
                else if (data_in == 1'b1)
                    next_state = FALL; // wait for falling edge
                else
                    next_state = IDLE; // fail-safe fallback
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out = 1 when we detect the falling edge completing the pulse: state FALL and next_state IDLE with data_in=0
            if (state == FALL && data_in == 1'b0) 
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule