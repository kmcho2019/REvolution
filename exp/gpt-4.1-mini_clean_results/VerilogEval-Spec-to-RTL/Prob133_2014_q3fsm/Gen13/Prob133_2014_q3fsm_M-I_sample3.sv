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
    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2
    reg [1:0] w_count, next_w_count;      // counts number of w=1's in current 3-cycle window
    reg next_z;

    wire counter_en = (state == B); // Enable counters only in state B

    always @(*) begin
        // Defaults: keep current values if not enabled
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        next_z = 1'b0;

        case (state)
            A: begin
                // Wait for s=1 to move to B
                // Keep counters unchanged to reduce toggling
                if (s)
                    next_state = B;
                else
                    next_state = A;
                // Output z deasserted
                next_z = 1'b0;
            end
            B: begin
                next_state = B;
                if (cycle_cnt == 2) begin
                    // At the third cycle, compute z for next cycle
                    // Total w_count + current w (in current cycle) counts for 3 cycles
                    if (w_count + w == 2)
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;
                    // Reset counters after 3 cycles
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_count = w_count + w;
                end
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
            // Update counters only when in state B to reduce toggling
            if (counter_en) begin
                cycle_cnt <= next_cycle_cnt;
                w_count <= next_w_count;
            end
            // Update z register every cycle to keep output stable
            z <= next_z;
        end
    end

endmodule