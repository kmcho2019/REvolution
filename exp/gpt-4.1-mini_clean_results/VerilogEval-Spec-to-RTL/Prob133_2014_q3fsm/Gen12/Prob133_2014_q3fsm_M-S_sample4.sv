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
    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2
    reg [1:0] w_count, next_w_count;      // counts number of w=1's in current 3-cycle window
    reg next_z;

    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        next_z = 1'b0;

        case (state)
            A: begin
                next_z = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window
                    next_z = (w_count + w == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_count = w_count + w;
                end
            end
        endcase
    end

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
            z <= next_z;
        end
    end

endmodule