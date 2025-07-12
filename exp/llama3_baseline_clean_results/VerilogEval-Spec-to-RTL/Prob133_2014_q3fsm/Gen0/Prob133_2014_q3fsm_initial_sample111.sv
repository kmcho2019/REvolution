module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: A, 1: B, 2: B (counting w)
reg [1:0] count_w; // count of w = 1
reg [1:0] count_cycle; // count of cycles since state transition

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset state to A
        count_w <= 0;
        count_cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // transition to state B
                    count_w <= 0;
                    count_cycle <= 1;
                end else begin
                    state <= 0; // stay in state A
                end
            end
            1: begin // state B (counting w)
                count_w <= count_w + (w ? 1 : 0);
                count_cycle <= count_cycle + 1;
                if (count_cycle == 3) begin
                    if (count_w == 2) begin
                        z <= 1; // set z to 1 if w = 1 exactly twice
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // stay in state B
                    count_w <= 0;
                    count_cycle <= 1;
                end else begin
                    state <= 1; // stay in state B
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule