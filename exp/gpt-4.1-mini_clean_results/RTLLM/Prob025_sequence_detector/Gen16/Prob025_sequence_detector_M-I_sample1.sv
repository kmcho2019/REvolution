module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot FSM state encoding (5 states)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next-state logic using one-hot encoding
    always @(*) begin
        // Default next_state to all zeros to catch unintended latches
        next_state = 5'b00000;

        case (1'b1) // one-hot encoded state selector
            state[0]: begin // IDLE
                // Wait for first '1'
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            state[1]: begin // S1 (matched '1')
                // Expect '0' next to move to S2, else stay in S1 if '1'
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end
            state[2]: begin // S2 (matched '10')
                // Expect '0' next to move to S3, else restart at S1 if '1'
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end
            state[3]: begin // S3 (matched '100')
                // Expect '1' next to move to S4 (detected), else restart at IDLE
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            state[4]: begin // S4 (matched '1001', detection)
                // Allow overlap detection start: if data_in=1 go to S1 else IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE; // Safety fallback
        endcase
    end

    // State register and output logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output asserted when in S4 state
            sequence_detected <= (next_state == S4);
        end
    end

endmodule