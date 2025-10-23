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
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    state_t state, next_state;
    reg [3:0] pattern_sr;  // Shift register for pattern detection (4 bits)
    reg [1:0] shift_cnt;

    // State and counters update
    always @(posedge clk) begin
        if (reset) begin
            state      <= SEARCH;
            pattern_sr <= 4'b0000;
            shift_cnt  <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SEARCH) begin
                // Shift in new data for pattern detection
                pattern_sr <= {pattern_sr[2:0], data};
            end else begin
                // Keep pattern_sr stable outside SEARCH
                pattern_sr <= pattern_sr;
            end

            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 2'd1;
            end else begin
                shift_cnt <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Check if last 4 bits equal 1101 (binary 4'b1101 == 13)
                if (pattern_sr == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 2'd3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Outputs
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule