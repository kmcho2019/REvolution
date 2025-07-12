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

    localparam [1:0]
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;    // for pattern detection (shifted every cycle in SEARCH)
    reg [2:0] shift_count;    // count 4 shift cycles (0 to 3)

    // Sequential: state, pattern_reg, shift_count with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'd0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == SEARCH) begin
                pattern_reg <= {pattern_reg[2:0], data};
                shift_count <= 3'd0;
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH: 
                // Detect pattern 1101 in pattern_reg
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            SHIFT:
                // After 4 shift cycles, go to COUNT
                if (shift_count == 3'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            COUNT:
                // Wait for done_counting
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            DONE:
                // Wait for ack to restart pattern detection
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            default:
                next_state = SEARCH;
        endcase
    end

    // Outputs are Moore type from current state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule