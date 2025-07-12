module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // 0: IDLE, 1: FOUND_1, 2: FOUND_11, 3: FOUND_110, 4: FOUND_SEQ
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        start_shifting_reg <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if (data) begin
                    state <= 1; // FOUND_1
                end
            end
            1: begin // FOUND_1
                if (data) begin
                    state <= 2; // FOUND_11
                end else begin
                    state <= 0; // IDLE
                end
            end
            2: begin // FOUND_11
                if (!data) begin
                    state <= 3; // FOUND_110
                end else begin
                    state <= 1; // FOUND_1
                end
            end
            3: begin // FOUND_110
                if (data) begin
                    state <= 4; // FOUND_SEQ
                end else begin
                    state <= 0; // IDLE
                end
            end
            4: begin // FOUND_SEQ
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule