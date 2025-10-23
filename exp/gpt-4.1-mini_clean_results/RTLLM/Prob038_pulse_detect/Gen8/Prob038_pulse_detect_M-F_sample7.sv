module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam WAIT_LOW       = 2'd0; // waiting for data_in=0 (start)
    localparam WAIT_HIGH      = 2'd1; // detected 0, waiting for 1
    localparam WAIT_LOW2      = 2'd2; // detected 1, waiting for 0 (pulse end)
    localparam PULSE_DETECTED = 2'd3; // pulse detected, output=1 for one cycle

    reg [1:0] state, next_state;

    // Sequential: state update and data_out generation (Moore output based on current state)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= WAIT_LOW;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when current state is PULSE_DETECTED
            data_out <= (state == PULSE_DETECTED) ? 1'b1 : 1'b0;
        end
    end

    // Combinational: next state logic
    always @(*) begin
        case (state)
            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = WAIT_LOW;
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW2;
                else if (data_in == 1'b0)
                    next_state = WAIT_HIGH; // stay if still 0
                else
                    next_state = WAIT_LOW; // fallback (should not occur)
            end

            WAIT_LOW2: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else if (data_in == 1'b1)
                    next_state = WAIT_LOW2; // remain waiting for 0
                else
                    next_state = WAIT_LOW; // fallback
            end

            PULSE_DETECTED: begin
                // After outputting pulse detection, restart detection from current input
                if (data_in == 1'b0)
                    next_state = WAIT_HIGH;
                else
                    next_state = WAIT_LOW;
            end

            default: begin
                next_state = WAIT_LOW;
            end
        endcase
    end

endmodule