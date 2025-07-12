module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot encoded states (7 states)
    localparam SEARCH0 = 7'b0000001;
    localparam SEARCH1 = 7'b0000010;
    localparam SEARCH2 = 7'b0000100;
    localparam SEARCH3 = 7'b0001000;
    localparam SHIFT   = 7'b0010000;
    localparam COUNT   = 7'b0100000;
    localparam DONE    = 7'b1000000;

    reg [6:0] state, next_state;
    reg [1:0] shift_count;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Increment shift counter only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next-state combinational logic
    always @(*) begin
        // Default hold current state
        next_state = state;

        case (1'b1)
            state[0]: begin // SEARCH0
                // Wait for '1' to start pattern detection
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
            end
            state[1]: begin // SEARCH1 (matched '1')
                // Expect second '1' for '11'
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
            end
            state[2]: begin // SEARCH2 (matched '11')
                // Expect '0' next
                if (~data)
                    next_state = SEARCH3;
                else
                    next_state = SEARCH2; // stay here if another '1' (overlapping)
            end
            state[3]: begin // SEARCH3 (matched '110')
                // Expect last bit '1' to complete '1101'
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
            end
            state[4]: begin // SHIFT - shift_ena asserted for exactly 4 cycles
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            state[5]: begin // COUNT - counting delay, wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            state[6]: begin // DONE - assert done until ack received
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH0;
        endcase
    end

    // Outputs combinational logic using assign statements
    assign shift_ena = state[4];
    assign counting  = state[5];
    assign done      = state[6];

endmodule