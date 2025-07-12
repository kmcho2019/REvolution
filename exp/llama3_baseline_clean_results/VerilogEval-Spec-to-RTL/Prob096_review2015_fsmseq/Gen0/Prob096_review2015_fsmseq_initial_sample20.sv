module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 2 bits for 4 states (S0 to S3)

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to S0
        start_shifting <= 0;
    end else begin
        case (state)
            2'b00: begin // S0
                if (data) begin
                    state <= 2'b01; // '1' detected, move to S1
                end else begin
                    state <= 2'b00; // Stay in S0
                end
            end
            2'b01: begin // S1
                if (data) begin
                    state <= 2'b10; // '11' detected, move to S2
                end else begin
                    state <= 2'b00; // Reset to S0
                end
            end
            2'b10: begin // S2
                if (data) begin
                    state <= 2'b10; // Stay in S2
                end else begin
                    state <= 2'b11; // '110' detected, move to S3
                end
            end
            2'b11: begin // S3
                if (data) begin
                    state <= 2'b00; // Reset to S0
                end else begin
                    state <= 2'b00; // Sequence not found, reset to S0
                    start_shifting <= 1; // Set start_shifting to 1
                end
            end
            default: state <= 2'b00; // Invalid state, reset to S0
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end else if (start_shifting) begin
        start_shifting <= 1;
    end else begin
        case (state)
            2'b11: begin
                if (~data) begin
                    start_shifting <= 1;
                end
            end
        endcase
    end
end

endmodule