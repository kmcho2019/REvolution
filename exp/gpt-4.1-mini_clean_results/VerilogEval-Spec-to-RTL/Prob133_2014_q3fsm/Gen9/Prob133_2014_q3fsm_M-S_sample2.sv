module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0, B = 1'b1;
    reg state;
    reg [1:0] cycle_cnt; // counts 0..2
    reg [1:0] w_count;   // counts w=1 in current group

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_count <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    cycle_cnt <= cycle_cnt + 2'd1;
                    w_count <= w_count + w;

                    if (cycle_cnt == 2) begin
                        z <= (w_count + w == 2) ? 1'b1 : 1'b0;
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end else begin
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule