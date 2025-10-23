module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_count;     // counts 0..2 cycles in each 3-cycle window
    reg [1:0] w_count_current; // counts w=1 in current window
    reg [1:0] w_count_prev;    // counts w=1 in previous window to generate z

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count_current <= 2'd0;
            w_count_prev <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count_current <= 2'd0;
                    w_count_prev <= 2'd0;
                    if (s == 1'b1) begin
                        state <= B;
                        // start counting in B at cycle_count=0
                        cycle_count <= 2'd0;
                        w_count_current <= w; // first cycle count of w
                        w_count_prev <= 2'd0;
                        z <= 1'b0;
                    end else begin
                        state <= A;
                    end
                end

                B: begin
                    // Output z based on w_count_prev (previous window)
                    // z=1 if exactly 2 of previous 3 w were 1, else 0
                    z <= (w_count_prev == 2);

                    if (cycle_count == 2) begin
                        // End of current 3-cycle window
                        cycle_count <= 2'd0;

                        // Move current w_count to w_count_prev for next cycle's output
                        w_count_prev <= w_count_current;

                        // Start counting new window: reset current count with current w
                        w_count_current <= w;
                    end else begin
                        // Continue counting current window
                        cycle_count <= cycle_count + 1;

                        // Accumulate w_count_current with current w
                        w_count_current <= w_count_current + w;

                        // w_count_prev stays the same to keep output stable this cycle
                        w_count_prev <= w_count_prev;
                    end
                    // state remains B
                end

                default: begin
                    state <= A;
                    cycle_count <= 2'd0;
                    w_count_current <= 2'd0;
                    w_count_prev <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule