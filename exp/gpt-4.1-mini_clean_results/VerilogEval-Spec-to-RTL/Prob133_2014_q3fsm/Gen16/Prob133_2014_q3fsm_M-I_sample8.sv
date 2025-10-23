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

    reg state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_sum;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_sum <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_sum <= 2'd0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    if (cycle_cnt == 2) begin
                        // After third input of w, output z = 1 if exactly two of three w's are 1
                        z <= ((w_sum + w) == 2);
                        // reset counters for next 3 cycles
                        cycle_cnt <= 2'd0;
                        w_sum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 2'd1;
                        w_sum <= w_sum + w;
                    end
                    state <= B;
                end

                default: begin
                    // Defensive coding
                    state <= A;
                    cycle_cnt <= 2'd0;
                    w_sum <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule