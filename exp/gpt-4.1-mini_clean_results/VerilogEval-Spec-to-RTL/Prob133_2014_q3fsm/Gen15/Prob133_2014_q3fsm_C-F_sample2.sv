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

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0..2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;     // count of w=1 in 3 cycles

    reg z_next; // next cycle output of z (registered for timing stability)

    // Clock enable for counters only in state B
    wire cnt_en = (state == B);

    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            A: begin
                // Wait for s=1
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;

                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // On 3rd cycle (counting 0,1,2), produce output z based on accumulated count + current w
                    // Mealy-style immediate output combined with registered z for stable timing
                    z_next = ((w_accum + w) == 2);
                    next_cycle_cnt = 2'd0; // reset for next window
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate w and increment cycle counter
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Update counters only in B to save power (clock enable style)
            if (cnt_en) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            // Register output z for timing stability and glitch avoidance
            z <= z_next;
        end
    end

endmodule