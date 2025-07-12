module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // S0: 2'b00, S1: 2'b01, S2: 2'b10, S3: 2'b11, S4: 2'b00 ( wraps around to S0 with start_shifting = 1)

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to S0
        start_shifting <= 0;
    end else begin
        case (state)
            2'b00: begin // S0
                if (data) begin
                    state <= 2'b01; // Transition to S1
                end else begin
                    state <= 2'b00; // Stay in S0
                end
            end
            2'b01: begin // S1
                if (data) begin
                    state <= 2'b10; // Transition to S2
                end else begin
                    state <= 2'b00; // Go back to S0
                end
            end
            2'b10: begin // S2
                if (~data) begin
                    state <= 2'b11; // Transition to S3
                end else begin
                    state <= 2'b01; // Go back to S1
                end
            end
            2'b11: begin // S3
                if (data) begin
                    state <= 2'b00; // Transition to S0 with start_shifting = 1
                    start_shifting <= 1;
                end else begin
                    state <= 2'b00; // Go back to S0
                end
            end
            default: begin
                state <= 2'b00; // Stay in S0 with start_shifting = 1
            end
        endcase
    end
end

endmodule