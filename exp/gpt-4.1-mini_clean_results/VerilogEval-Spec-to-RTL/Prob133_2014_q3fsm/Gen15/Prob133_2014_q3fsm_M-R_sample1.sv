module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_accum, next_w_accum;
    reg z_next;

    // Next state and data path logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;

        case(state)
            A: begin
                // Stay in A if s=0, else go to B
                if (s)
                    next_state = B;
                else
                    next_state = A;

                // Reset counters in A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // Completed 3 cycles, reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate w and increment cycle count
                    next_cycle_cnt = cycle_cnt + 1;
                    next_w_accum = w_accum + w;
                end
            end
            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
            end
        endcase
    end

    // Output logic combinational, Moore style: output depends on state and stored counters
    always @(*) begin
        // Default output low
        z_next = 1'b0;
        if (state == B && cycle_cnt == 2) begin
            // Assert z if exactly two of three w samples were 1
            if ((w_accum + w) == 2)
                z_next = 1'b1;
        end
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
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

endmodule