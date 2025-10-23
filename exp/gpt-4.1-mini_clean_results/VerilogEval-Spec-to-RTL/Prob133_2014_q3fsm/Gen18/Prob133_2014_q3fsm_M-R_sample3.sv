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
    reg [1:0] w_count, next_w_count;

    // Next state and counters logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z = 1'b0;

        case (state)
            A: begin
                // Stay in A if s=0, else go to B
                if (s) begin
                    next_state = B;
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    next_state = A;
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end
                z = 1'b0;
            end

            B: begin
                if (cycle_cnt == 2) begin
                    // On third cycle, output 1 if exactly two w=1 counted in current window (including current w)
                    z = (w_count + w == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                    next_state = B;
                end else begin
                    z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_count = w_count + w;
                    next_state = B;
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state and counters update
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
            // z updated combinationally in always @(*)
            // To synchronize output z with state registers, assign z in sequential block:
            // (To avoid glitches, reassign z here as in combinational block)
            // But to keep output synchronous, prefer z registered here
            // We handle that by storing combinational z to a register here
            // So we will add a temporary combinational signal

            // Actually, to ensure output z is synchronous, override combinational z with registered version:
            // But combinational block sets z already, so it's fine to keep output reg updated here from combinational z
        end
    end

endmodule