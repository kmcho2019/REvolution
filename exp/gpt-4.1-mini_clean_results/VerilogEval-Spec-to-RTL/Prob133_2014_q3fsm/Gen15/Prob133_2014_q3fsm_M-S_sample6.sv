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
    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_sum, next_w_sum;
    reg next_z;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_sum = w_sum;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_sum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;
                if (cycle_cnt == 2) begin
                    // After third cycle, check if exactly two w's are 1 (including current w)
                    next_z = ((w_sum + w) == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_sum = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_sum = w_sum + w;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_sum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_sum <= next_w_sum;
            end else begin
                cycle_cnt <= 2'd0;
                w_sum <= 2'd0;
            end
            z <= next_z;
        end
    end

endmodule