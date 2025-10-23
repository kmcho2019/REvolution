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

    // One-hot state encoding (7 bits for 7 states)
    localparam S_SEARCH0 = 7'b0000001,
               S_SEARCH1 = 7'b0000010,
               S_SEARCH2 = 7'b0000100,
               S_SEARCH3 = 7'b0001000,
               S_SHIFT   = 7'b0010000,
               S_COUNT   = 7'b0100000,
               S_DONE    = 7'b1000000;

    reg [6:0] state, next_state;
    reg [1:0] shift_count;

    // State and shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Increment shift_count only in S_SHIFT, else clear
            if (state == S_SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (1'b1) // one-hot state decoding

            state[S_SEARCH0]: begin
                // Wait for first '1'
                if (data == 1'b1)
                    next_state = S_SEARCH1;
                else
                    next_state = S_SEARCH0;
            end

            state[S_SEARCH1]: begin
                // Expect second '1'
                if (data == 1'b1)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end

            state[S_SEARCH2]: begin
                // Expect '0'
                if (data == 1'b0)
                    next_state = S_SEARCH3;
                else if (data == 1'b1)
                    next_state = S_SEARCH2; // remain searching
                else
                    next_state = S_SEARCH0;
            end

            state[S_SEARCH3]: begin
                // Expect final '1' for 1101
                if (data == 1'b1)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end

            state[S_SHIFT]: begin
                // Shift in 4 bits exactly (count 0 to 3)
                if (shift_count == 2'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end

            state[S_COUNT]: begin
                // Wait for counting done
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end

            state[S_DONE]: begin
                // Wait for ack
                if (ack)
                    next_state = S_SEARCH0;
                else
                    next_state = S_DONE;
            end

            default: next_state = S_SEARCH0;
        endcase
    end

    // Outputs driven by state bits
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule