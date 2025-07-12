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

    // State encoding
    typedef enum logic [1:0] {
        S_SEARCH = 2'd0,
        S_SHIFT  = 2'd1,
        S_COUNT  = 2'd2,
        S_DONE   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Shift counter for the 4 shift cycles
    reg [1:0] shift_count;

    // State register and pattern shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_shift <= 4'd0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == S_SEARCH) begin
                // Shift in new data for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
            end
            if (state == S_SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic as a function
    function state_t fn_next_state(
        input state_t curr_state,
        input [3:0] pattern,
        input [1:0] shift_cnt,
        input done_counting_i,
        input ack_i
    );
        begin
            case (curr_state)
                S_SEARCH: fn_next_state = (pattern == 4'b1101) ? S_SHIFT : S_SEARCH;
                S_SHIFT:  fn_next_state = (shift_cnt == 2'd3) ? S_COUNT : S_SHIFT;
                S_COUNT:  fn_next_state = done_counting_i ? S_DONE : S_COUNT;
                S_DONE:   fn_next_state = ack_i ? S_SEARCH : S_DONE;
                default:  fn_next_state = S_SEARCH;
            endcase
        end
    endfunction

    always @(*) begin
        next_state = fn_next_state(state, pattern_shift, shift_count, done_counting, ack);
    end

    // Output logic as combinational assignments
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule