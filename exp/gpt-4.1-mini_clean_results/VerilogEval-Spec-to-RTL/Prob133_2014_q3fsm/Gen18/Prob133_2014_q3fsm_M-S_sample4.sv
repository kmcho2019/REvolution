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
    reg [1:0] cycle_cnt; // counts 0,1,2 cycles in B
    reg [1:0] w_accum;   // counts number of w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            z <= 1'b0; // default output low unless set otherwise

            case (state)
                A: begin
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                end

                B: begin
                    w_accum <= w_accum + w;
                    if (cycle_cnt == 2) begin
                        z <= (w_accum + w == 2);
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
            endcase
        end
    end

endmodule