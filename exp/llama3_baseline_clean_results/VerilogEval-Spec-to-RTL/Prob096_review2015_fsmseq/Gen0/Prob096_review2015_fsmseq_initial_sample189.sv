module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [2:0] state; // 0: IDLE, 1: SEEN_1, 2: SEEN_11, 3: SEEN_110, 4: SEEN_1101
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // SEEN_1
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // SEEN_11
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 3;
                end
            end
            3: begin // SEEN_110
                if (data) begin
                    state <= 1;
                end else begin
                    state <= 4;
                end
            end
            4: begin // SEEN_1101
                state <= 4;
            end
        endcase
        if (state == 4) begin
            start_shifting_reg <= 1;
        end else begin
            start_shifting_reg <= 0;
        end
    end
end

assign start_shifting = start_shifting_reg;

endmodule