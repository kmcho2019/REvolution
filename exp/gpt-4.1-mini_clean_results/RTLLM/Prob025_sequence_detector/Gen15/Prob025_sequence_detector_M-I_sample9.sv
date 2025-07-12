module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoded states (5 states)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next-state logic with one-hot encoding
    always @(*) begin
        // Default next_state is IDLE to avoid inferred latches
        next_state = IDLE;

        case (1'b1)  // One-hot encoding decode using casez style with priority on single bit set
            state[0]: begin // IDLE
                // If input is '1', move to S1; else stay IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            state[1]: begin // S1 - matched '1'
                // Next bit '0' => S2; '1' => remain in S1 (overlapping)
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            state[2]: begin // S2 - matched '10'
                // Next bit '0' => S3; '1' => S1 (restart detection with new '1')
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end

            state[3]: begin // S3 - matched '100'
                // Next bit '1' => S4 (sequence detected); '0' => IDLE
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            state[4]: begin // S4 - matched '1001'
                // After detection, allow overlap: if input '1', go to S1; else IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and output logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert sequence_detected when in S4 state (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

endmodule