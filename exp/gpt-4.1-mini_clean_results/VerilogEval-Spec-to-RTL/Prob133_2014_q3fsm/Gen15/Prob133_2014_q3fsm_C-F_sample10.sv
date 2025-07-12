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

    reg [1:0] cycle_cnt, next_cycle_cnt; // 3-cycle counter: 0 to 2
    reg [1:0] w_accum, next_w_accum;     // accumulate w=1 count in window

    reg z_next;

    // Combinational next-state and outputs
    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            A: begin
                // Remain in A if s=0, else transition to B
                if (s)
                    next_state = B;
                else
                    next_state = A;
                // Counters unchanged in A to reduce switching
                next_cycle_cnt = cycle_cnt;
                next_w_accum = w_accum;
                z_next = 1'b0;
            end

            B: begin
                next_state = B;
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: set z=1 if exactly two w=1 counted
                    z_next = ((w_accum + w) == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate w and increment cycle count
                    z_next = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: update state, counters, and output at posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Update counters only in state B to reduce toggling
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                // Retain counters in A to reduce unnecessary toggling (power saving)
                cycle_cnt <= cycle_cnt;
                w_accum <= w_accum;
            end

            z <= z_next; // Registered output
        end
    end

endmodule