module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // States
    localparam STATE_COUNT  = 2'd0; // Counting consecutive ones
    localparam STATE_OUTPUT = 2'd1; // One-cycle output state
    localparam STATE_ERROR  = 2'd2; // Error state (7 or more ones)

    reg [1:0] state, next_state;

    // Count of consecutive ones (max 7)
    reg [3:0] count_ones, next_count_ones;

    // Output type in output state
    typedef enum reg [1:0] {
        OUT_NONE = 2'd0,
        OUT_DISC = 2'd1,
        OUT_FLAG = 2'd2
    } out_type_t;
    reg [1:0] out_type, next_out_type;

    // Sequential logic: state, count, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state       <= STATE_COUNT;
            count_ones  <= 4'd0;
            disc        <= 1'b0;
            flag        <= 1'b0;
            err         <= 1'b0;
            out_type    <= OUT_NONE;
        end else begin
            state       <= next_state;
            count_ones  <= next_count_ones;
            out_type    <= next_out_type;

            // Outputs asserted only in OUTPUT or ERROR states
            disc <= (next_state == STATE_OUTPUT) && (next_out_type == OUT_DISC);
            flag <= (next_state == STATE_OUTPUT) && (next_out_type == OUT_FLAG);
            err  <= (next_state == STATE_ERROR);
        end
    end

    // Next state logic and count update
    always @(*) begin
        // Default assignments
        next_state      = state;
        next_count_ones = count_ones;
        next_out_type   = OUT_NONE;

        case(state)
            STATE_COUNT: begin
                if (in) begin
                    // increment count but cap at 7 for error detection
                    if (count_ones < 7)
                        next_count_ones = count_ones + 1;
                    else
                        next_count_ones = count_ones;

                    // Check conditions for output or error when input is zero next cycle
                    // Actually, outputs trigger on zero after counts
                    // So if count_ones+1 reaches 7 or more, error immediately
                    if (count_ones + 1 >= 7) begin
                        // 7 or more ones - go to error next cycle
                        next_state = STATE_ERROR;
                        next_out_type = OUT_NONE;
                    end else begin
                        // Still counting, stay in counting state
                        next_state = STATE_COUNT;
                    end
                end else begin
                    // in == 0: zero after a number of ones triggers possible output or reset count

                    case (count_ones)
                        5: begin
                            // After 5 ones then zero: discard zero bit next cycle
                            next_state = STATE_OUTPUT;
                            next_out_type = OUT_DISC;
                        end
                        6: begin
                            // After 6 ones then zero: flag next cycle
                            next_state = STATE_OUTPUT;
                            next_out_type = OUT_FLAG;
                        end
                        default: begin
                            // For any other count (including zero), no special output
                            next_state = STATE_COUNT;
                            next_out_type = OUT_NONE;
                        end
                    endcase
                    // Reset count_ones on zero input
                    next_count_ones = 4'd0;
                end
            end

            STATE_OUTPUT: begin
                // Output asserted this cycle, return to counting state next cycle
                next_state = STATE_COUNT;
                next_count_ones = 4'd0;
                next_out_type = OUT_NONE;
            end

            STATE_ERROR: begin
                // Stay in error state while input is 1, clear when input is 0
                if (in == 1'b0) begin
                    next_state = STATE_COUNT;
                    next_count_ones = 4'd0;
                    next_out_type = OUT_NONE;
                end else begin
                    next_state = STATE_ERROR;
                    next_count_ones = count_ones; // hold count (not critical here)
                    next_out_type = OUT_NONE;
                end
            end

            default: begin
                next_state = STATE_COUNT;
                next_count_ones = 4'd0;
                next_out_type = OUT_NONE;
            end
        endcase
    end

endmodule