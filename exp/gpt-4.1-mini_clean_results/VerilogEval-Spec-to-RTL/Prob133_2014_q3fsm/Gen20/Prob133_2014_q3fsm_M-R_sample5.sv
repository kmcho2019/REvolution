module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);
    // State encoding (one-hot style)
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt;         // counts 0,1,2 for 3 cycles
    reg [1:0] window_w_count;    // count of w=1 in the current 3-cycle window
    reg [1:0] last_window_count; // registered count from previous window
    reg state_B_active;          // flag to know if in state B, for use in output

    // State and counters synchronous process
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_cnt <= 2'd0;
            window_w_count <= 2'd0;
            last_window_count <= 2'd0;
            state_B_active <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    cycle_cnt <= 2'd0;
                    window_w_count <= 2'd0;
                    last_window_count <= 2'd0;
                    state_B_active <= 1'b0;
                    if (s)
                        state <= STATE_B;
                    else
                        state <= STATE_A;
                end
                STATE_B: begin
                    state <= STATE_B;
                    // Increment cycle count
                    if (cycle_cnt == 2) begin
                        // End of 3-cycle window: latch current window count, reset counters
                        last_window_count <= window_w_count + w;
                        cycle_cnt <= 2'd0;
                        window_w_count <= 2'd0;
                        state_B_active <= 1'b1; // signal that output can be asserted next cycle
                    end else begin
                        cycle_cnt <= cycle_cnt + 2'd1;
                        window_w_count <= window_w_count + w;
                        last_window_count <= last_window_count; // hold
                        state_B_active <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Output z asserted for one clock cycle after each 3-cycle window if exactly two w=1
    // Since last_window_count is the count of 'w=1' in last window, and state_B_active indicates output cycle
    assign z = (state == STATE_B) && state_B_active && (last_window_count == 2);

endmodule