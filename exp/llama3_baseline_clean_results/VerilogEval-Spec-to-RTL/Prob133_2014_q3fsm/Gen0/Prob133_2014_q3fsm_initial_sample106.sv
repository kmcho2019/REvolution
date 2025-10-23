module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // A = 0, B = 1, C1 = 2
reg [1:0] cnt; // counter for w = 1
reg [1:0] clk_cnt; // counter for clock cycles
reg flag; // flag to indicate if we are in the counting phase

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // A
        cnt <= 0;
        clk_cnt <= 0;
        flag <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // A
                if (s) begin
                    state <= 1; // B
                end
            end
            1: begin // B
                state <= 2; // C1
                flag <= 1;
                cnt <= 0;
                clk_cnt <= 0;
            end
            2: begin // C1
                if (flag) begin
                    if (w) begin
                        cnt <= cnt + 1;
                    end
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == 2) begin
                        flag <= 0;
                    end
                end else begin
                    if (cnt == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // B
                end
            end
            default: state <= 0; // A
        endcase
    end
end

endmodule