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

    // One-hot state encoding
    localparam S_SEARCH0 = 7'd1 << 0; // 0x01
    localparam S_SEARCH1 = 7'd1 << 1; // 0x02
    localparam S_SEARCH2 = 7'd1 << 2; // 0x04
    localparam S_SEARCH3 = 7'd1 << 3; // 0x08
    localparam S_SHIFT   = 7'd1 << 4; // 0x10
    localparam S_COUNT   = 7'd1 << 5; // 0x20
    localparam S_DONE    = 7'd1 << 6; // 0x40

    reg [6:0] state, next_state; // one-hot encoding uses 7 bits
    reg [2:0] shift_count;       // count 0 to 3 for shift cycles

    // State register and shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == S_SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = 7'd0;
        case (1'b1)
            state[S_SEARCH0]: begin
                // Wait for first '1' of pattern
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
                // Expect '0', but allow overlapping by reentering S_SEARCH2 if input '1'
                if (data == 1'b0)
                    next_state = S_SEARCH3;
                else if (data == 1'b1)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH3]: begin
                // Expect final '1'
                if (data == 1'b1)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SHIFT]: begin
                if (shift_count == 3'd3)
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

    // Outputs directly assigned from state signals
    assign shift_ena = state[S_SHIFT];
    assign counting  = state[S_COUNT];
    assign done      = state[S_DONE];

endmodule