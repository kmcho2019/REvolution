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
    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_accum, next_w_accum;
    reg z_next;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            A: begin
                // Stay in A until s=1, clear counters and output
                if (s)
                    next_state = B;
                else
                    next_state = A;

                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: check if exactly two w=1's
                    z_next = ((w_accum + w) == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    z_next = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            // Update counters only in B to reduce toggling in A
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule