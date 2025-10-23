module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 0: Idle, 1: S1, 2: S2, 3: S3, 4 and above are unused (Found)

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data) begin
                    state <= 1;
                end
            end
            1: begin // S1
                if (data) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin // S2
                if (~data) begin
                    state <= 3;
                end else begin
                    state <= 1; // Received another '1', stay in S1 logic
                end
            end
            3: begin // S3
                if (data) begin
                    state <= 4; // Found
                    start_shifting <= 1;
                end else begin
                    state <= 0;
                end
            end
            default: begin // Found
                // Do nothing, remain in Found state until reset
            end
        endcase
    end
end

endmodule