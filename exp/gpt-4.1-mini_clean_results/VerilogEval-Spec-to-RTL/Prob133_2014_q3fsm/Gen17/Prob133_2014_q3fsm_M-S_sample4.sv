module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // States
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0 to 2
    reg [1:0] w_count, next_w_count;      // counts number of 1s in w

    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z = 1'b0;  // default output 0

        case (state)
            A: begin
                // Wait for s=1 to move to B
                if (s)
                    next_state = B;
                else
                    next_state = A;
                // counters reset in A
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                z = 1'b0;
            end

            B: begin
                // In B, sample w for 3 cycles
                if (cycle_cnt == 2) begin
                    // Last cycle: check if w_count + current w == 2
                    if (w_count + w == 2)
                        z = 1'b1;
                    else
                        z = 1'b0;
                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    // Increment cycle count and accumulate w
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_count = w_count + w;
                    z = 1'b0;
                end
                next_state = B;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z;
        end
    end

endmodule