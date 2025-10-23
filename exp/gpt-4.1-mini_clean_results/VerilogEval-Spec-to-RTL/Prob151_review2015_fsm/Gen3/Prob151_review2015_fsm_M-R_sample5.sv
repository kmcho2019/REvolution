module TopModule (
    input        clk,
    input        reset,
    input        data,
    input        done_counting,
    input        ack,
    output       shift_ena,
    output       counting,
    output       done
);

    // State encoding
    typedef enum logic [1:0] {
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    // State register
    reg state_reg, next_state;
    reg [1:0] state; // 2-bit state
    reg [1:0] next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Shift cycle counter (counts 0..3 to total 4 cycles)
    reg [2:0] shift_cnt;

    // Update pattern shift register every clock cycle (synchronous reset)
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;

            // Manage shift counter in SHIFT state
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 3'd1;
            end else begin
                shift_cnt <= 3'd0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;  // default hold state
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 3'd3) // after 4 cycles 0..3 completed
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
        endcase
    end

    // Outputs purely combinational based on current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule