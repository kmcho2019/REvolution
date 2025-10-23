module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable (A = 0, B = 1)
reg [1:0] cnt; // Counter for clock cycles
reg [1:0] w_cnt; // Counter for w = 1

always @(posedge clk) begin
    if (reset) begin // Reset state
        state <= 0;
        cnt <= 0;
        w_cnt <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1;
                    cnt <= 1;
                    w_cnt <= w;
                    z <= 0;
                end else begin
                    state <= 0;
                    cnt <= 0;
                    w_cnt <= 0;
                    z <= 0;
                end
            end
            1: begin // State B
                if (cnt < 3) begin
                    cnt <= cnt + 1;
                    if (w) begin
                        w_cnt <= w_cnt + 1;
                    end
                    z <= 0;
                end else begin
                    if (w_cnt == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    cnt <= 1;
                    w_cnt <= w;
                end
            end
        endcase
    end
end

endmodule