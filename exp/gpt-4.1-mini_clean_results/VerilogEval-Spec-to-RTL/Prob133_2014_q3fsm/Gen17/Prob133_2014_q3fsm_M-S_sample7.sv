module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic {A, B} state_t;
    state_t state;

    reg [1:0] cycle_cnt;
    reg [1:0] w_sum;
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_sum <= 2'd0;
            z <= 1'b0;
        end else begin
            z <= z_next;
            case(state)
                A: begin
                    z_next <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_sum <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    if (cycle_cnt == 2) begin
                        z_next <= ((w_sum + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_sum <= 2'd0;
                    end else begin
                        z_next <= 1'b0;
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_sum <= w_sum + w;
                    end
                end
            endcase
        end
    end

endmodule