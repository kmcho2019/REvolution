module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // 0: idle, 1: seen_1, 2: seen_11, 3: seen_110, 4: seen_1101
reg start_shifting_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin
                    state <= 1;
                end
            end
            1: begin // seen_1
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // seen_11
                if (data) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin // seen_110
                if (data) begin
                    state <= 0;
                end else begin
                    state <= 4;
                    start_shifting_reg <= 1;
                end
            end
            4: begin // seen_1101
                start_shifting_reg <= 1;
            end
            default: state <= 0;
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule