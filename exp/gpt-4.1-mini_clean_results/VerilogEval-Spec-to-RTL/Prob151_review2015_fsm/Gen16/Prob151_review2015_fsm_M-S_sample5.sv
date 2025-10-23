module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // FSM states: SEARCH (waiting for 1101), SHIFT (shift in 4 bits), COUNT (wait done_counting), DONE (wait ack)
    localparam [1:0]
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] pattern_shift_reg; // shift register to detect 1101 pattern
    reg [1:0] shift_count;       // count 4 shift cycles

    // Sequential logic: state, pattern_shift_reg, shift_count updates
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift_reg <= 4'b0000;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Shift in data for pattern detection only in SEARCH
            if (state == SEARCH) begin
                pattern_shift_reg <= {pattern_shift_reg[2:0], data};
            end
            // Shift count increments only in SHIFT
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH: begin
                // Detect pattern 1101 in pattern_shift_reg
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                if (shift_count == 2'd3)  // completed 4 shifts (0 to 3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
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

    // Outputs as Moore signals from current state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule