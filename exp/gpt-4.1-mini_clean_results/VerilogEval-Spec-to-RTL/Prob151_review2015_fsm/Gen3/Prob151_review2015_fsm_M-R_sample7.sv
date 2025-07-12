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

    // State one-hot encoding
    reg idle, shift, counting_st, done_st;
    reg [3:0] pattern_shift_reg;  // For detecting pattern 1101 only in IDLE
    reg [2:0] shift_count;        // Counts from 0 to 3 in SHIFT state

    // Next state signals
    reg idle_next, shift_next, counting_next, done_next;

    // Pattern detection: shift register updated only in IDLE state
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0000;
        end else if (idle) begin
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
        end
    end

    // State registers update
    always @(posedge clk) begin
        if (reset) begin
            idle <= 1'b1;
            shift <= 1'b0;
            counting_st <= 1'b0;
            done_st <= 1'b0;
            shift_count <= 3'd0;
        end else begin
            idle <= idle_next;
            shift <= shift_next;
            counting_st <= counting_next;
            done_st <= done_next;

            // shift_count counts in SHIFT state, reset otherwise
            if (shift)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        // Default: hold current state
        idle_next = idle;
        shift_next = shift;
        counting_next = counting_st;
        done_next = done_st;

        if (idle) begin
            if (pattern_shift_reg == 4'b1101) begin
                idle_next = 1'b0;
                shift_next = 1'b1;
            end
        end else if (shift) begin
            // After 4 cycles (count from 0 to 3) in SHIFT, go to COUNTING
            if (shift_count == 3'd3) begin
                shift_next = 1'b0;
                counting_next = 1'b1;
            end
        end else if (counting_st) begin
            if (done_counting) begin
                counting_next = 1'b0;
                done_next = 1'b1;
            end
        end else if (done_st) begin
            if (ack) begin
                done_next = 1'b0;
                idle_next = 1'b1;
            end
        end
    end

    // Outputs combinational based on state registers
    assign shift_ena = shift;
    assign counting = counting_st;
    assign done = done_st;

endmodule