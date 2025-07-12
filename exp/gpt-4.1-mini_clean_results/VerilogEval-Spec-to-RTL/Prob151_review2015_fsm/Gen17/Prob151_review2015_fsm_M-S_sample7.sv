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

    // State encoding (2-bit)
    localparam SEARCH = 2'd0; // looking for pattern "1101"
    localparam SHIFT  = 2'd1; // shifting 4 bits
    localparam COUNT  = 2'd2; // waiting for counters done
    localparam DONE   = 2'd3; // done, waiting for ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_reg;  // shift register for last 4 bits to detect pattern

    // Shift register and state registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
            pattern_reg <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == SEARCH) begin
                // shift in incoming data for pattern detection
                pattern_reg <= {pattern_reg[2:0], data};
            end else begin
                pattern_reg <= pattern_reg; // hold
            end

            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: 
                // detect pattern 1101 in pattern_reg after shift (bits[3:0])
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;

            SHIFT:
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;

            COUNT:
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;

            default:
                next_state = SEARCH;
        endcase
    end

    // Output assignments (Moore style)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule