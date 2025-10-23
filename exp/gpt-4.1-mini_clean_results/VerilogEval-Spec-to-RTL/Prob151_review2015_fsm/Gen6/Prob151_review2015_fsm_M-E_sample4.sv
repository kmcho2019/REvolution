module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    localparam WAIT_PATTERN = 2'd0,
               SHIFTING    = 2'd1,
               COUNTING    = 2'd2,
               DONE        = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit pattern shift register to detect 1101
    reg [3:0] pattern_reg;

    // 2-bit shift counter (counts 0 to 3)
    reg [1:0] shift_count;

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, pattern_reg, shift_count, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state       <= WAIT_PATTERN;
            pattern_reg <= 4'b0000;
            shift_count <= 2'd0;
            shift_ena   <= 1'b0;
            counting    <= 1'b0;
            done        <= 1'b0;
        end else begin
            // Shift in serial data for pattern detection unconditionally
            pattern_reg <= {pattern_reg[2:0], data};

            state <= next_state;

            case (next_state)
                WAIT_PATTERN: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                    shift_count <= 2'd0; // Reset shift counter
                end

                SHIFTING: begin
                    shift_ena <= 1'b1;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                    // Increment shift counter to track the 4 cycles
                    shift_count <= shift_count + 1'b1;
                end

                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b1;
                    done      <= 1'b0;
                    shift_count <= 2'd0; // Reset shift count, not used here
                end

                DONE: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b1;
                    shift_count <= 2'd0;
                end

                default: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                    shift_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT_PATTERN: begin
                // Wait until pattern detected
                if (pattern_reg == PATTERN)
                    next_state = SHIFTING;
                else
                    next_state = WAIT_PATTERN;
            end

            SHIFTING: begin
                // Shift 4 bits, counted by shift_count (0..3)
                if (shift_count == 2'd3)
                    next_state = COUNTING;
                else
                    next_state = SHIFTING;
            end

            COUNTING: begin
                // Wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                // Wait for ack to return to pattern search
                if (ack)
                    next_state = WAIT_PATTERN;
                else
                    next_state = DONE;
            end

            default: next_state = WAIT_PATTERN;
        endcase
    end

endmodule