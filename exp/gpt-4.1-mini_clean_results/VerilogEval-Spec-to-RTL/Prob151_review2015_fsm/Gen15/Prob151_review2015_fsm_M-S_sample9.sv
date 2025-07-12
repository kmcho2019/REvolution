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

    // State encoding (2 bits suffice now):
    typedef enum logic [1:0] {
        SEARCH = 2'd0, // searching for pattern 1101 in data stream
        SHIFT  = 2'd1, // shifting in 4 bits for delay duration
        COUNT  = 2'd2, // waiting for done_counting
        DONE   = 2'd3  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_reg;      // shift register to detect pattern
    reg [1:0] shift_count;      // counts 4 shift cycles

    // Pattern to detect: 1101 (binary 4'b1101)
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0000;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SEARCH) begin
                // Shift in new data bit
                pattern_reg <= {pattern_reg[2:0], data};
            end
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic (Moore FSM)
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_reg == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
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

    // Outputs combinationally driven by current state (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule