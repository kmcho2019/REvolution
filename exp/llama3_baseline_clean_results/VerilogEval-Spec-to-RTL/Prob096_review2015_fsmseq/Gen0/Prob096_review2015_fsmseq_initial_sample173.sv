module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [2:0] state; // 0: idle, 1: found_1, 2: found_11, 3: found_110, 4: found_sequence
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
            1: begin // found_1
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // found_11
                if (~data) begin
                    state <= 3;
                end else begin
                    state <= 1;
                end
            end
            3: begin // found_110
                if (data) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin // found_sequence
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule