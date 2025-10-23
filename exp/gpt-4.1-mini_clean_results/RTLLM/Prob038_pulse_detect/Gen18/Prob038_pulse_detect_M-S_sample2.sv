module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00, // Waiting for data_in=0
        WAIT_HIGH = 2'b01, // Detected 0, waiting for data_in=1
        WAIT_LOW  = 2'b10  // Detected 1, waiting for data_in=0 to confirm pulse
    } state_t;

    state_t state, next_state;
    reg data_in_d;

    // Delay data_in by one clock for edge detection and stable comparisons
    always @(posedge clk) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // FSM state transition and data_out generation
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Default data_out=0 each cycle, set to 1 only when pulse ends
            data_out <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Wait for stable 0 input
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // 0 detected, wait for rising edge
            end

            WAIT_HIGH: begin
                // Wait for rising edge 0->1
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // stay if still 0
                else
                    next_state = IDLE; // fallback
            end

            WAIT_LOW: begin
                // Wait for falling edge 1->0 confirming pulse
                if (data_in == 1'b0) begin
                    next_state = WAIT_HIGH; // ready for next pulse
                end else if (data_in == 1'b1) begin
                    next_state = WAIT_LOW; // still high
                end else begin
                    next_state = IDLE; // fallback
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Pulse detection: output 1 at cycle when state moves from WAIT_LOW and data_in falls to 0
    // To capture pulse end precisely, we check in sequential block:
    // When previous state WAIT_LOW and current data_in==0 => pulse detected
    reg state_d; // flag indicating previous cycle was WAIT_LOW

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_d <= 1'b0;
        end else begin
            state_d <= (state == WAIT_LOW);
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            if (state_d && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule