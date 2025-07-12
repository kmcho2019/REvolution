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

    // 2-bit cycle counter and 2-bit w accumulator packed in 4-bit register
    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_accum, next_w_accum;

    // Registered output enable and z value for next cycle
    reg z_next, z_reg;

    // State and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z_reg <= z_next;
            z <= z_reg;  // output z delayed by one cycle after decision
        end
    end

    // Next state and counters logic
    always @(*) begin
        // Defaults to hold values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;  // default no output

        case(state)
            A: begin
                z_next = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B;
            end

            B: begin
                // Increment cycle count and accumulate w
                next_cycle_cnt = cycle_cnt + 2'd1;
                next_w_accum = w_accum + w;

                if (cycle_cnt == 2) begin
                    // On the 3rd cycle, compute z_next based on total w count in this 3-cycle window
                    // w_accum holds count for previous 2 cycles, plus current w
                    if ((w_accum + w) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

endmodule