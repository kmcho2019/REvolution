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

    // State encoding (3-bit binary)
    localparam S_SEARCH = 3'd0,
               S_SHIFT  = 3'd1,
               S_COUNT  = 3'd2,
               S_DONE   = 3'd3;

    reg [2:0] state, next_state;

    // Shift register to hold last 4 bits for pattern detection (only updated in SEARCH)
    reg [3:0] pattern_sr;

    // 2-bit shift counter for exactly 4 shift cycles
    reg [1:0] shift_count;

    // Pattern detection inside SEARCH state
    // Detect 1101 pattern in pattern_sr: pattern_sr == 4'b1101

    // Sequential logic: state, shift_count, and pattern_sr updates
    always @(posedge clk) begin
        if (reset) begin
            state       <= S_SEARCH;
            shift_count <= 2'd0;
            pattern_sr  <= 4'd0;
        end else begin
            state <= next_state;
            case (state)
                S_SEARCH: begin
                    // Shift in data into pattern_sr on each clock during SEARCH
                    pattern_sr <= {pattern_sr[2:0], data};
                    shift_count <= 2'd0; // reset shift count when not shifting
                end
                S_SHIFT: begin
                    shift_count <= shift_count + 2'd1;
                    // pattern_sr not updated in SHIFT, counters external handle shift data
                end
                default: begin
                    shift_count <= 2'd0;
                    // pattern_sr holds its value outside SEARCH and SHIFT (or can hold last)
                    // No update to pattern_sr here
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S_SEARCH: begin
                // Look for pattern 1101 in pattern_sr
                if (pattern_sr == 4'b1101)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH;
            end
            S_SHIFT: begin
                // Shift in 4 bits exactly (counting from 0 to 3)
                if (shift_count == 2'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end
            S_COUNT: begin
                // Wait for counting done signal
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            S_DONE: begin
                // Wait for ack to return to search
                if (ack)
                    next_state = S_SEARCH;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    // Outputs derived combinationally from state
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule