module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'd0;
            w_count   <= 2'd0;
            z         <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    // Freeze counters in state A unless s=1 to reduce toggling
                    if (s) begin
                        state <= B;
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end
                end

                B: begin
                    if (cycle_cnt < 2) begin
                        cycle_cnt <= cycle_cnt + 1;
                        // Increment w_count only if w=1, to avoid addition complexity
                        if (w)
                            w_count <= w_count + 1;
                        z <= 1'b0;
                    end else begin
                        // On 3rd cycle, include current w and decide z accordingly
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule