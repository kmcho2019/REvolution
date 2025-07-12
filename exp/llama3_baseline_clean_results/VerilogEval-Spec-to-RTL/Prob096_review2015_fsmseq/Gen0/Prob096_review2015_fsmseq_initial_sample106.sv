module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 0: Idle, 1: S1, 2: S2, 3: S3, 4: Shift

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1) begin
                    state <= 1; // S1
                end else begin
                    state <= 0; // Idle
                end
            end
            1: begin // S1
                if (data == 1) begin
                    state <= 2; // S2
                end else begin
                    state <= 0; // Idle
                end
            end
            2: begin // S2
                if (data == 0) begin
                    state <= 3; // S3
                end else begin
                    state <= 1; // S1
                end
            end
            3: begin // S3
                if (data == 1) begin
                    state <= 4; // Shift
                end else begin
                    state <= 0; // Idle
                end
            end
            4: begin // Shift
                start_shifting <= 1;
            end
            default: begin
                state <= 0; // Idle
            end
        endcase
    end
end

endmodule