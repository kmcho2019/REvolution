module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // FSM states
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0 to 2 (3 cycles)
    reg [1:0] w_accum, next_w_accum;     // count of w=1 in window

    reg z_next;

    // Combinational next state and outputs
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
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
                next_state = B;
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: output 1 if exactly two w=1 in last 3 cycles (w_accum + current w)
                    z_next = ((w_accum + w) == 2);
                    // reset counters for next window
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

    // Sequential logic with gated register updates to reduce toggling in state A
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                // Hold zero counters in state A to reduce toggling
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule