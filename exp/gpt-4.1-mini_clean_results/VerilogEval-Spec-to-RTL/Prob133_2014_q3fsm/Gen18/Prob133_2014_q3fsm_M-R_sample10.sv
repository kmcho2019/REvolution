module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_sum, next_w_sum;
    reg z_reg, next_z;

    always @(*) begin
        // Default next values
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
                if (cycle_cnt == 2) begin
                    // On the third cycle, evaluate sum including current w
                    next_z = ((w_sum + w) == 2);
                    // Reset counters for the next 3-cycle window
                    next_cycle_cnt = 2'd0;
                    next_w_sum = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_sum = w_sum + w;
                end
                next_state = B;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_sum <= 2'd0;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_sum <= next_w_sum;
            z_reg <= next_z;
        end
    end

    // Output register
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= z_reg;
    end

endmodule