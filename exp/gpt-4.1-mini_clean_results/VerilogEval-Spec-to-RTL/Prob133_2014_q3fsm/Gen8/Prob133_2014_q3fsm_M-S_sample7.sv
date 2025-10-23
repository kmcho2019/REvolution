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

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0,1,2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;     // counts number of w=1's in 3 cycles
    reg z_next;

    // Combinational next-state and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                // Remain in A if s=0, else move to B
                if (s)
                    next_state = B;
                else
                    next_state = A;

                // Reset counters and z in A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: decide output z next cycle
                    z_next = (w_accum + w) == 2; // exactly two w=1's in 3 cycles
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Continue accumulating
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic: state, counters, and output update
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