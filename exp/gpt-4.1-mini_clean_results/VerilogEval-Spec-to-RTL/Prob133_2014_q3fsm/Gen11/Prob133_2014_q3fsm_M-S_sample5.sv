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
    reg [1:0] cycle_cnt; // counts 0 to 2 for three cycles
    reg [1:0] w_sum;     // accumulates number of w=1 in 3 cycles

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
                end
                B: begin
                    // accumulate w and increment cycle count
                    w_sum <= w_sum + w;
                    cycle_cnt <= cycle_cnt + 2'd1;
                    z <= 1'b0;

                    if (cycle_cnt == 2) begin
                        // At end of 3rd cycle: output next cycle if exactly two w's were 1
                        z <= ((w_sum + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_sum <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule