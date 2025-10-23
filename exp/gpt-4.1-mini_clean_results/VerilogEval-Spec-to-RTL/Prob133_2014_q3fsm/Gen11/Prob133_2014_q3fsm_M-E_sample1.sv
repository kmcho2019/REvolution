module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A  = 2'd0,
        B0 = 2'd1,
        B1 = 2'd2
    } state_t;

    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2
    reg [1:0] w_accum, next_w_accum;      // accumulates w count in 3 cycles

    reg z_next;

    always @(*) begin
        // Defaults
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
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // Accumulate w and increment cycle count
                next_w_accum = w_accum + w;
                next_cycle_cnt = cycle_cnt + 2'd1;
                next_state = B1;
                z_next = 1'b0; // output only after finishing 3 cycles
            end

            B1: begin
                next_w_accum = w_accum + w;
                next_cycle_cnt = cycle_cnt + 2'd1;
                if (cycle_cnt == 2) begin
                    // Finished 3 cycles (counting 0,1,2)
                    // Output in next cycle if exactly two w's were high
                    // w_accum currently has count after previous cycle,
                    // plus current w in this cycle sums to total_w
                    // But here cycle_cnt=2 means this is 3rd cycle,
                    // and next cycle output z=1 if total_w==2
                    // So output is registered in next cycle (which will be B0 or A)
                    next_state = B0;
                    z_next = 1'b0;
                end else begin
                    next_state = B0;
                    z_next = 1'b0;
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

    // To produce output z delayed by one cycle after counting window,
    // track when cycle_cnt==2 and save total w count, then assert z on next cycle.

    reg output_valid;
    reg [1:0] total_w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
            output_valid <= 1'b0;
            total_w_count <= 2'd0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;

            // When in B1 and cycle_cnt==2, we've completed 3 cycles
            // The total_w_count is sum of w_accum + w at that cycle
            if (state == B1 && cycle_cnt == 2) begin
                total_w_count <= w_accum + w;
                output_valid <= 1'b1;
            end else begin
                output_valid <= 1'b0;
            end

            // Output z is 1 only one cycle after counting window if total_w_count==2
            if (output_valid && total_w_count == 2) begin
                z <= 1'b1;
            end else begin
                z <= 1'b0;
            end
        end
    end

endmodule