module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 00: IDLE, 01: S1, 10: S2, 11: S3, 2'b100: FOUND

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state machine to IDLE
        start_shifting <= 0; // Reset output
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data) begin
                    state <= 2'b01; // Move to S1 on detecting first '1'
                end
            end
            2'b01: begin // S1
                if (data) begin
                    state <= 2'b10; // Move to S2 on detecting second '1'
                end else begin
                    state <= 2'b00; // Back to IDLE on detecting '0'
                end
            end
            2'b10: begin // S2
                if (~data) begin
                    state <= 2'b11; // Move to S3 on detecting '0'
                end else begin
                    state <= 2'b01; // Back to S1 on detecting '1'
                end
            end
            2'b11: begin // S3
                if (data) begin
                    state <= 2'b100; // Move to FOUND on detecting '1'
                    start_shifting <= 1; // Set output
                end else begin
                    state <= 2'b00; // Back to IDLE on detecting '0'
                end
            end
            2'b100: begin // FOUND
                start_shifting <= 1; // Keep output high
            end
            default: begin
                state <= 2'b00; // Default to IDLE
            end
        endcase
    end
end

endmodule