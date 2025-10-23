module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state; // 0: IDLE, 1: SEEN_1, 2: SEEN_11, 3: SEEN_110, 4: SEEN_1101
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1) begin
                    state <= 1; // SEEN_1
                end else begin
                    state <= 0; // IDLE
                end
            end
            1: begin // SEEN_1
                if (data == 1) begin
                    state <= 2; // SEEN_11
                end else begin
                    state <= 0; // IDLE
                end
            end
            2: begin // SEEN_11
                if (data == 0) begin
                    state <= 3; // SEEN_110
                end else begin
                    state <= 1; // SEEN_1
                end
            end
            3: begin // SEEN_110
                if (data == 1) begin
                    state <= 4; // SEEN_1101
                    start_shifting_reg <= 1;
                end else begin
                    state <= 0; // IDLE
                end
            end
            4: begin // SEEN_1101
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule