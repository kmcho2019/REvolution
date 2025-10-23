module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;   // cycle count modulo 3: 0..2
    reg [2:0] w_shift, next_w_shift;       // shift register holding last 3 w samples

    reg z_next;

    // Count number of 1's in 3-bit vector combinationally
    wire [1:0] w_ones_count;
    assign w_ones_count = w_shift[0] + w_shift[1] + w_shift[2];

    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_shift = w_shift;
        z_next = 1'b0;

        case(state)
            A: begin
                next_cycle_cnt = 2'd0;
                next_w_shift = 3'b000;
                z_next = 1'b0;

                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // On third cycle, check count of w=1 in w_shift plus current w
                    // Shift in current w to get full 3-cycle window before evaluating
                    // So next_w_shift includes current w
                    // Then count ones and set z_next accordingly
                    next_w_shift = {w_shift[1:0], w};

                    // Calculate ones count for next_w_shift in combinational, so after shift
                    // Wait for posedge clk to update registers and output z

                    // Since combinational logic cannot read next_w_shift assigned here,
                    // we'll compute w_ones_count based on next_w_shift in the sequential block.
                    // To solve this, assign z_next = 1 here only if count is 2.

                    // Use temporary variable for ones count combinationally:
                    // We compute z_next at posedge clock instead.

                    next_cycle_cnt = 2'd0;
                    z_next = 1'b0; // will update in sequential logic
                end else begin
                    // Shift in w, increment cycle counter
                    next_w_shift = {w_shift[1:0], w};
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    z_next = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_shift <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_shift <= next_w_shift;

                // Output z one cycle after the third sample is taken (cycle_cnt == 2)
                // Detect that we just finished 3-cycle window when next_cycle_cnt==0 and cycle_cnt==2 in previous cycle
                if (cycle_cnt == 2) begin
                    // count ones in current w_shift plus next shifted in w in next_w_shift
                    // next_w_shift updated in current cycle, so count ones in next_w_shift
                    // Compute ones count:
                    // next_w_shift bits already assigned, count them now

                    // Count ones in next_w_shift (3-bit)
                    // next_w_shift is a register, combinational operations possible here

                    // Compute ones count with a simple sum:
                    // Assign z = 1 if exactly two 1's

                    integer ones;
                    ones = next_w_shift[0] + next_w_shift[1] + next_w_shift[2];
                    z <= (ones == 2);
                end else begin
                    z <= 1'b0;
                end
            end else begin
                // In state A, clear counters and output z=0
                cycle_cnt <= 2'd0;
                w_shift <= 3'b000;
                z <= 1'b0;
            end
        end
    end

endmodule