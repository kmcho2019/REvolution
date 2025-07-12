module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 0: Idle, 1: Found1, 2: Found11, 3: Found110, 4: Found1101

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // Found1
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                end else begin
                    state <= 1;
                end
            end
            2: begin // Found11
                if (data == 0) begin
                    state <= 3;
                end else if (data == 1) begin
                    state <= 1;
                end else begin
                    state <= 2;
                end
            end
            3: begin // Found110
                if (data == 1) begin
                    state <= 4;
                    start_shifting <= 1;
                end else if (data == 0) begin
                    state <= 0;
                end else begin
                    state <= 3;
                end
            end
            4: begin // Found1101
                start_shifting <= 1;
            end
            default: begin
                state <= 0;
                start_shifting <= 0;
            end
        endcase
    end
end

endmodule