module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // One-hot encoded states
    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;

    reg [1:0] state, next_state;

    // Separate cycle counter and w accumulator
    reg [1:0] cycle_cnt, next_cycle_cnt;  // Counts 0 to 2
    reg [1:0] w_accum, next_w_accum;      // Accumulates count of w=1

    reg z_next;

    // State transition combinational logic
    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            STATE_A: begin
                // Reset counters and output in A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;

                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // Stay in B always
                next_state = STATE_B;

                if (cycle_cnt == 2) begin
                    // At the end of 3 cycles (0-based count)
                    // Check if exactly two w's were 1
                    if ((w_accum + w) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                    // Reset counters for next group of 3 cycles
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Increment counters
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;
                end
            end

            default: begin
                next_state = STATE_A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic block for state, counters, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

endmodule