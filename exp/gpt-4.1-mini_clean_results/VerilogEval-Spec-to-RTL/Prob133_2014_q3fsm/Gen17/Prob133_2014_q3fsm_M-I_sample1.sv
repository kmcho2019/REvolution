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
    reg [1:0] cycle_cnt;     // 0 to 2 counting cycles in B
    reg [1:0] w_accum;       // count of w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    if (cycle_cnt == 2) begin
                        // End of 3-cycle window: check if exactly 2 out of 3 w=1
                        // w_accum contains count of first 2 cycles, add current w
                        z <= ((w_accum + w) == 2);
                        // reset counters for next window
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 1;
                        w_accum <= w_accum + w;
                    end
                    // stay in state B indefinitely once entered
                end
            endcase
        end
    end

endmodule