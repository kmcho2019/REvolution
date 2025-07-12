module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_count, next_w_count;
    reg z_next;

    // Combinational next-state logic and outputs
    always @* begin
        next_state     = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count   = w_count;
        z_next         = 1'b0;

        case (state)
            A: begin
                // In A, stay in A if s=0; move to B if s=1
                if (s)
                    next_state = B;
                next_cycle_cnt = 2'd0;
                next_w_count   = 2'd0;
            end
            B: begin
                // Increment cycle count mod 3
                if (cycle_cnt == 2)
                    next_cycle_cnt = 2'd0;
                else
                    next_cycle_cnt = cycle_cnt + 1;

                // Accumulate w counts over 3 cycles
                next_w_count = w_count + w;

                // When 3 cycles are completed, decide output and reset count
                if (cycle_cnt == 2) begin
                    z_next = (next_w_count == 2);
                    next_w_count = 2'd0;
                end
            end
        endcase
    end

    // Sequential block for state, counters, and output registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'd0;
            w_count   <= 2'd0;
            z         <= 1'b0;
        end else begin
            state     <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count   <= next_w_count;
            z         <= z_next;
        end
    end

endmodule