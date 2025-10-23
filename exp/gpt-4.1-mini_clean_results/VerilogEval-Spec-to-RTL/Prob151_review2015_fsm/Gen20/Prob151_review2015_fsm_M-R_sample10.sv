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

    // One-hot state encoding (7 bits)
    localparam S_SEARCH0 = 7'b000_0001,
               S_SEARCH1 = 7'b000_0010,
               S_SEARCH2 = 7'b000_0100,
               S_SEARCH3 = 7'b000_1000,
               S_SHIFT   = 7'b001_0000,
               S_COUNT   = 7'b010_0000,
               S_DONE    = 7'b100_0000;

    reg [6:0] state, next_state;
    reg [3:0] shift_count;

    // State register and shift count update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH0;
            shift_count <= 4'd0;
        end else begin
            state <= next_state;

            if (state == S_SHIFT)
                shift_count <= shift_count + 4'd1;
            else
                shift_count <= 4'd0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (1'b1)
            state[S_SEARCH0]: begin
                if (data)
                    next_state = S_SEARCH1;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH1]: begin
                if (data)
                    next_state = S_SEARCH2;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SEARCH2]: begin
                if (~data)
                    next_state = S_SEARCH3;
                else // data==1
                    next_state = S_SEARCH2; // stay to handle overlapping pattern
            end
            state[S_SEARCH3]: begin
                if (data)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH0;
            end
            state[S_SHIFT]: begin
                if (shift_count == 4'd3)
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

    // Outputs assigned from state bits
    assign shift_ena = state[S_SHIFT];
    assign counting  = state[S_COUNT];
    assign done      = state[S_DONE];

endmodule