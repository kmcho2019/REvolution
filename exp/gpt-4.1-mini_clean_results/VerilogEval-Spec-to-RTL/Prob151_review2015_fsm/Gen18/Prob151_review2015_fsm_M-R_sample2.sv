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

    // One-hot encoded states (7 bits)
    localparam [6:0]
        S_SEARCH  = 7'b000_0001,
        S_SHIFT   = 7'b000_0010,
        S_COUNT   = 7'b000_0100,
        S_DONE    = 7'b000_1000;

    // Since pattern 1101 is 4 bits, and next states are fixed, we only need these 4 states:
    // We'll use bits [0] for SEARCH, [1] for SHIFT, [2] for COUNT, [3] for DONE.
    // The other bits are unused here.

    reg [6:0] state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] pattern_sr;

    // 3-bit shift counter (counts 0..3)
    reg [2:0] shift_count;

    // State and pattern shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_sr <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            // Shift pattern register in every cycle
            pattern_sr <= {pattern_sr[2:0], data};

            case (state)
                S_SEARCH: begin
                    // Detect pattern 1101 in pattern_sr
                    if (pattern_sr == 4'b1101)
                        next_state <= S_SHIFT;
                    else
                        next_state <= S_SEARCH;

                    shift_count <= 3'd0;  // reset shift counter when not shifting
                end
                S_SHIFT: begin
                    // Increment shift_count, and move to COUNT after 4 shifts (count from 0)
                    if (shift_count == 3'd3) begin
                        next_state <= S_COUNT;
                        shift_count <= 3'd0;
                    end else begin
                        next_state <= S_SHIFT;
                        shift_count <= shift_count + 3'd1;
                    end
                end
                S_COUNT: begin
                    // Wait for done_counting signal
                    if (done_counting)
                        next_state <= S_DONE;
                    else
                        next_state <= S_COUNT;

                    shift_count <= 3'd0;
                end
                S_DONE: begin
                    // Wait for ack signal before returning to search
                    if (ack)
                        next_state <= S_SEARCH;
                    else
                        next_state <= S_DONE;

                    shift_count <= 3'd0;
                end
                default: begin
                    next_state <= S_SEARCH;
                    shift_count <= 3'd0;
                end
            endcase

            state <= next_state;
        end
    end

    // Output logic derived from one-hot state encoding
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule