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
    localparam SEARCH      = 2'd0,
               SHIFT       = 2'd1,
               WAIT_COUNT  = 2'd2,
               DONE        = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;    // For pattern detection
    reg [1:0] shift_count;    // Counts 0 to 3 shifts in SHIFT state

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state       <= SEARCH;
            pattern_reg <= 4'd0;
            shift_count <= 2'd0;
            shift_ena   <= 1'b0;
            counting    <= 1'b0;
            done        <= 1'b0;
        end else begin
            state <= next_state;

            // Shift pattern_reg only in SEARCH state
            if (state == SEARCH)
                pattern_reg <= {pattern_reg[2:0], data};

            // In SHIFT state increment shift_count
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;

            // Outputs based on current state
            shift_ena <= (state == SHIFT);
            counting  <= (state == WAIT_COUNT);
            done      <= (state == DONE);
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            SEARCH: begin
                if (pattern_reg == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = WAIT_COUNT;
                else
                    next_state = SHIFT;
            end

            WAIT_COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = WAIT_COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule