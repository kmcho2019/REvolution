module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 4 states: IDLE (2'b00), S1 (2'b01), S2 (2'b10), S3 (2'b11), SHIFT (we use start_shifting instead of a separate state)

always @ (posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0;
        state <= 2'b00; // IDLE
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data) begin
                    state <= 2'b01; // S1
                end
            end
            2'b01: begin // S1
                if (data) begin
                    state <= 2'b10; // S2
                end else begin
                    state <= 2'b00; // back to IDLE
                end
            end
            2'b10: begin // S2
                if (~data) begin
                    state <= 2'b11; // S3
                end else begin
                    state <= 2'b01; // S1
                end
            end
            2'b11: begin // S3
                if (data) begin
                    start_shifting <= 1'b1;
                end else begin
                    state <= 2'b00; // back to IDLE
                end
            end
            default: ; // do nothing, SHIFT state is handled by start_shifting
        endcase
    end
end

endmodule