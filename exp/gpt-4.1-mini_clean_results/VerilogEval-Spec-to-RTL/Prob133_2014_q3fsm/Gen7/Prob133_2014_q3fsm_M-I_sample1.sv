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
    reg [1:0] cycle_cnt, next_cycle_cnt; // counts from 0 to 2 for 3 cycles
    reg [1:0] w_count, next_w_count;     // counts w=1 in current 3-cycle group
    reg z_next;

    // State and counters update (sequential)
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

    // Next-state and counters logic (combinational)
    always @(*) begin
        // Default assignments to avoid inferred latches
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_next = z; // default hold z to reduce toggling

        case(state)
            A: begin
                // In A, reset counters and output
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                z_next = 1'b0;
                if (s)
                    next_state = B;
            end

            B: begin
                // Increment counters only in B
                if (cycle_cnt == 2) begin
                    // After 3rd cycle (counting from 0)
                    // Include current w in count
                    if ((w_count + w) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                    // Reset counters for next group
                    next_cycle_cnt = 2'b00;
                    next_w_count = 2'b00;
                    next_state = B; // remain in B
                end else begin
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_count = w_count + w;
                    z_next = 1'b0; // output zero except on 3rd cycle
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                z_next = 1'b0;
            end
        endcase
    end

endmodule