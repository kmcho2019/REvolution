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

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0 to 2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;     // counts number of w=1 in 3 cycles

    reg z_next; // delayed z output

    // Next-state logic
    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                // Reset counters and output in state A
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
                    // After counting 3 cycles (0,1,2), decide output based on w_accum + current w
                    z_next = ((w_accum + w) == 2);
                    next_cycle_cnt = 2'd0;  // reset counters for next 3-cycle window
                    next_w_accum = 2'd0;
                end else begin
                    // accumulate w and increment cycle counter
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic: update state, counters and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Update counters only in state B to reduce switching power
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            z <= z_next; // register delayed output
        end
    end

endmodule