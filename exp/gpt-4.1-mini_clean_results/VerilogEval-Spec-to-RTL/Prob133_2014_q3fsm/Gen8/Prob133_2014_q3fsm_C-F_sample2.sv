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
    reg [1:0] cycle_cnt, next_cycle_cnt; // counts cycles in groups of 3: 0..2
    reg [1:0] w_count, next_w_count;     // counts w=1 occurrences in current group
    reg z_next;

    // Sequential logic: update state, counters, and output on rising edge of clk
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

    // Combinational logic: next state, counters, and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_next = 1'b0; // default z zero to reduce toggling except when asserted

        case(state)
            A: begin
                // Reset counters and output in state A
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                z_next = 1'b0;
                if (s)
                    next_state = B;
            end

            B: begin
                if (cycle_cnt == 2) begin
                    // On the 3rd cycle (0-based counting), include current w
                    // Evaluate if exactly two w=1 in the group of 3 cycles
                    if ((w_count + w) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    // Reset counters for next 3-cycle group
                    next_cycle_cnt = 2'b00;
                    next_w_count = 2'b00;

                    // Remain in B
                    next_state = B;
                end else begin
                    // Accumulate w_count and increment cycle counter
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_count = w_count + w;
                    z_next = 1'b0; // keep output zero during intermediate cycles
                end
            end

            default: begin
                // Safe default fallback
                next_state = A;
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                z_next = 1'b0;
            end
        endcase
    end

endmodule