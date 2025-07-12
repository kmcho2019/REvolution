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

    // One-hot state encoding for clarity and timing optimization
    localparam S_SEARCH0 = 7'd1 << 0,
               S_SEARCH1 = 7'd1 << 1,
               S_SEARCH2 = 7'd1 << 2,
               S_SEARCH3 = 7'd1 << 3,
               S_SHIFT   = 7'd1 << 4,
               S_COUNT   = 7'd1 << 5,
               S_DONE    = 7'd1 << 6;

    reg [6:0] state, next_state;

    // 2-bit shift counter for counting 4 shift cycles
    reg [1:0] shift_counter;

    // State and shift_counter register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_counter <= 2'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT)
                shift_counter <= shift_counter + 2'd1;
            else
                shift_counter <= 2'd0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (1'b1) // One-hot style case
            state[S_SEARCH0]: begin
                if (data == 1'b1)
                    next_state = S_SEARCH1;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH1]: begin
                if (data == 1'b1)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH2]: begin
                if (data == 1'b0)
                    next_state = S_SEARCH3;
                else if (data == 1'b1)
                    next_state = S_SEARCH2; // Overlapping pattern detection
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH3]: begin
                if (data == 1'b1)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SHIFT]: begin
                if (shift_counter == 2'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end
            state[S_COUNT]: begin
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            state[S_DONE]: begin
                if (ack)
                    next_state = S_SEARCH0;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH0;
        endcase
    end

    // Outputs directly from states
    assign shift_ena = state[S_SHIFT];
    assign counting  = state[S_COUNT];
    assign done      = state[S_DONE];

endmodule