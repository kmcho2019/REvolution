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
    reg [1:0] w_accum;

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
                        // On 3rd cycle: determine output based on total count of w=1 in 3 cycles
                        z <= ((w_accum + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 1;
                        w_accum <= w_accum + w;
                    end
                    // remain in B
                end
            endcase
        end
    end

endmodule