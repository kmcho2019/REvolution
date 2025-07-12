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
    reg [1:0] cycle_cnt, next_cycle_cnt; // cycle count 0..2
    reg [1:0] w_count, next_w_count;     // count of w=1 in current group
    reg w_reg;                           // registered w in state B

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            w_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            w_reg <= (state == B) ? w : 1'b0; // register w only in B, else zero
            z <= (state == B && cycle_cnt == 2) ? (w_count == 2) : 1'b0;
        end
    end

    // Next state and counters logic
    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;

        case(state)
            A: begin
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                if (s)
                    next_state = B;
            end

            B: begin
                if (cycle_cnt == 2) begin
                    // End of 3-cycle group: reset counters
                    next_cycle_cnt = 2'b00;
                    next_w_count = 2'b00;
                    next_state = B;
                end else begin
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_count = w_count + w_reg; // accumulate registered w
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
            end
        endcase
    end

endmodule