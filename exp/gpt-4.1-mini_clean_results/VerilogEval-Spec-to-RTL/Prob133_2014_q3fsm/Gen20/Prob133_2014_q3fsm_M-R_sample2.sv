module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // Enumerated states for clarity
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // Counters for cycles and counting w=1 occurrences
    logic [1:0] cycle_cnt, next_cycle_cnt;
    logic [1:0] w_count, next_w_count;

    // Combinational signal to decide next output z
    logic z_int, z_next;

    // Combinational next-state logic and next counters
    always @(*) begin
        // Defaults: remain in current state and counters unchanged, z_int 0
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_int = 1'b0;

        case (state)
            A: begin
                // In state A, wait for s=1 to move to B, counters reset
                if (s)
                    next_state = B;
                else
                    next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                z_int = 1'b0;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // On the 3rd cycle, determine output and reset counters for next window
                    z_int = ((w_count + w) == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    // Accumulate w count and increment cycle counter
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_count = w_count + w;
                    z_int = 1'b0;
                end
            end
        endcase
    end

    // Sequential block: register state, counters and output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z_int;
        end
    end

endmodule