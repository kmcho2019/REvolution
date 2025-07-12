module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt;  // counts 0 to 2
    reg [1:0] count_w;    // count of w=1 in current window

    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'd0;
            count_w   <= 2'd0;
            z         <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                A: begin
                    cycle_cnt <= 2'd0;
                    count_w   <= 2'd0;
                    z         <= 1'b0;
                end
                B: begin
                    if (cycle_cnt < 2) begin
                        cycle_cnt <= cycle_cnt + 1;
                        count_w   <= count_w + w;
                        z         <= 1'b0;
                    end else begin
                        // 3rd cycle: sample w, output z based on total count
                        z         <= (count_w + w == 2) ? 1'b1 : 1'b0;
                        cycle_cnt <= 2'd0;
                        count_w   <= 2'd0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule