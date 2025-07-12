module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum logic [1:0] {
        IDLE      = 2'b00,
        WAIT_HIGH = 2'b01,
        WAIT_LOW  = 2'b10
    } state_t;

    state_t state, next_state;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default data_out to 0, except when pulse detected
            data_out <= 1'b0;
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // waiting for rising edge
                else
                    next_state = IDLE;       // stay in IDLE if not zero
            end
            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;   // rising edge detected, wait for falling edge
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH;  // still zero, keep waiting for rising edge
                else
                    next_state = IDLE;       // invalid input, back to IDLE
            end
            WAIT_LOW: begin
                if (data_in == 1'b0) begin
                    next_state = WAIT_HIGH;  // pulse completed, restart detection
                end else if (data_in == 1'b1) begin
                    next_state = WAIT_LOW;   // stay in WAIT_LOW if input went high again (invalid pulse)
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic separated from FSM register update to assert pulse
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0; // default

            // Assert data_out when we detect transition 0->1->0 completed,
            // i.e. when in WAIT_LOW state and data_in is 0, which means pulse just finished
            if (state == WAIT_HIGH && data_in == 1'b1) begin
                // Transition from WAIT_HIGH to WAIT_LOW on rising edge: no output
                data_out <= 1'b0;
            end else if (state == WAIT_LOW && data_in == 1'b0) begin
                // This cycle completes the pulse 0->1->0
                data_out <= 1'b1;
            end
        end
    end

endmodule