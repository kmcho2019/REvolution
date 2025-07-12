module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t state, next_state;

    // Cycle counter counts from 0 to 2 (three cycles)
    reg [1:0] cycle_cnt, next_cycle_cnt;

    // Accumulator for number of times w=1 in current 3-cycle window
    reg [1:0] w_count, next_w_count;

    // Flag to indicate output z for next cycle
    reg z_flag, next_z_flag;

    // Combinational logic to compute next state and counters
    always @(*) begin
        // Defaults: hold values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        next_z_flag = 1'b0;

        case (state)
            STATE_A: begin
                // In reset state A, output zero, zero counters
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                next_z_flag = 1'b0;

                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                if (cycle_cnt == 2) begin
                    // On third cycle, decide output for next cycle
                    next_z_flag = ((w_count + w) == 2);
                    // Reset counters for next 3-cycle window
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                    // Stay in state B (always stay in B after entering)
                    next_state = STATE_B;
                end else begin
                    // In first or second cycle, increment counters
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_count = w_count + w;
                    next_z_flag = 1'b0;
                    next_state = STATE_B;
                end
            end
        endcase
    end

    // Sequential logic to update state, counters, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            z_flag <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z_flag <= next_z_flag;
            // Output z is registered flag delayed by one cycle
            z <= z_flag;
        end
    end

endmodule