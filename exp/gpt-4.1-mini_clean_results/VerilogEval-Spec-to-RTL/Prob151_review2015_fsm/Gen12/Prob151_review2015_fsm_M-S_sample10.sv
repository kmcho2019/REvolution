module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    localparam [1:0]
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_shift; // to hold last 4 bits for pattern detection

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
            pattern_shift <= 4'd0;
        end else begin
            state <= next_state;
            if (state == SEARCH) begin
                // Shift in data bit for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH: 
                // Detect pattern 1101 (binary 4'b1101 = 13 decimal)
                next_state = (pattern_shift == 4'b1101) ? SHIFT : SEARCH;
            SHIFT:
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:
                next_state = done_counting ? DONE : COUNT;
            DONE:
                next_state = ack ? SEARCH : DONE;
            default:
                next_state = SEARCH;
        endcase
    end

    // Outputs as Moore outputs based on current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule