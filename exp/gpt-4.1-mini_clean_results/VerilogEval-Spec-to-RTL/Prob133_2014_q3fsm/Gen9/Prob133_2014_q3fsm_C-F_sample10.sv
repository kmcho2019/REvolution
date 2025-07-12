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

    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_accum, next_w_accum;
    reg z_next;

    // Sequential logic: state, counters, output update
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

    // Combinational logic: next state and counters enable logic
    always @(*) begin
        // Default values to hold current state and values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;  // default output zero except updated below

        case (state)
            A: begin
                // In A, reset counters and output, wait for s=1
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Update counters and accumulate w only in B
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: evaluate z in this cycle
                    // z = 1 if exactly two ones in the 3 cycles (w_accum + w == 2)
                    z_next = ((w_accum + w) == 2);

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                    next_state = B; // remain in B
                end else begin
                    // Continue counting cycles and accumulating w
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;  // output zero except after window ends
                    next_state = B;
                end
            end
            default: begin
                // Safe defaults
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

endmodule