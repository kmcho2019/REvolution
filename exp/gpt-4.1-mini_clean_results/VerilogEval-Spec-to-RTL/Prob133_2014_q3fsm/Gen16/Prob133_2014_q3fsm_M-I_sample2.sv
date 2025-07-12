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

    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;      // counts number of w=1 in window (max 3)

    reg w_reg; // registered w input to reduce combinational fan-in

    reg z_pulse; // internal signal asserting z condition one cycle earlier

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            w_reg <= 1'b0;
            z <= 1'b0;
            z_pulse <= 1'b0;
        end else begin
            w_reg <= w; // register w

            state <= next_state;

            // Update counters only in state B to minimize toggling
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            z_pulse <= 1'b0; // default no pulse

            z <= z_pulse; // output registered z with one cycle delay
        end
    end

    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_pulse = 1'b0;

        case (state)
            A: begin
                // In reset state, wait for s=1 to go to B
                if (s)
                    next_state = B;
                else
                    next_state = A;

                // Reset counters in A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
            end
            B: begin
                // During B, accumulate w=1 counts over 3 cycles
                if (cycle_cnt == 2) begin
                    // On the 3rd cycle, check if total w=1 count (including current w_reg) == 2
                    if ((w_accum + w_reg) == 2)
                        z_pulse = 1'b1;
                    else
                        z_pulse = 1'b0;

                    // Reset counters for next 3-cycle window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate w_reg if it is 1
                    next_w_accum = w_accum + (w_reg ? 2'd1 : 2'd0);
                    next_cycle_cnt = cycle_cnt + 2'd1;
                end

                next_state = B;
            end
        endcase
    end

endmodule