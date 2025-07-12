module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 0: idle, 1: seen_1, 2: seen_11, 3: seen_110, 4: seen_1101

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1) begin
                    state <= 1;
                end
            end
            1: begin // seen_1
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                end
            end
            2: begin // seen_11
                if (data == 0) begin
                    state <= 3;
                end else if (data == 1) begin
                    state <= 2;
                end
            end
            3: begin // seen_110
                if (data == 1) begin
                    state <= 4;
                end else if (data == 0) begin
                    state <= 0;
                end
            end
            4: begin // seen_1101
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule