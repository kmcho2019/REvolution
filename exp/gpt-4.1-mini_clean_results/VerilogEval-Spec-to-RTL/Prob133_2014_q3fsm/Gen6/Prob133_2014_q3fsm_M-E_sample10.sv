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

    reg [1:0] cycle_cnt, next_cycle_cnt;    // 0..2 cycles in window
    reg [1:0] w_accum, next_w_accum;        // counts number of w=1 in current window
    reg z_next;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Accumulate w count
                next_w_accum = w_accum + w;
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window, output depends on accumulator
                    z_next = (next_w_accum == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                    next_state = B;
                end else begin
                    // Continue counting window cycles
                    next_cycle_cnt = cycle_cnt + 1;
                    z_next = 1'b0;
                    next_state = B;
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
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

endmodule