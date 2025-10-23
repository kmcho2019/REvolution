module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] cnt;
reg [1:0] w_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // State A
        cnt <= 0;
        w_cnt <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // State B
                    cnt <= 1;
                    w_cnt <= w ? 1 : 0;
                    z <= 0;
                end else begin
                    state <= 0; // Stay in State A
                end
            end
            1: begin // State B
                if (cnt < 3) begin
                    cnt <= cnt + 1;
                    if (w) begin
                        w_cnt <= w_cnt + 1;
                    end
                end else begin
                    if (w_cnt == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // Stay in State B
                    cnt <= 1;
                    w_cnt <= w ? 1 : 0;
                end
            end
        endcase
    end
end

endmodule