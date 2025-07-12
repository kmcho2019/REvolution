module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] state; // 4-bit state register

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000; // Reset to S0
        start_shifting <= 0;
    end else begin
        case (state)
            4'b0000: // S0
                if (data == 1'b1) begin
                    state <= 4'b0001; // Transition to S1 on '1'
                end
            4'b0001: // S1
                if (data == 1'b1) begin
                    state <= 4'b0010; // Transition to S2 on '1' after '1'
                end else begin
                    state <= 4'b0000; // Reset to S0 on '0'
                end
            4'b0010: // S2
                if (data == 1'b0) begin
                    state <= 4'b0011; // Transition to S3 on '0' after '11'
                end else begin
                    state <= 4'b0000; // Reset to S0 on '1' after '11'
                end
            4'b0011: // S3
                if (data == 1'b1) begin
                    state <= 4'b0100; // Transition to S4 on '1' after '110'
                end else begin
                    state <= 4'b0000; // Reset to S0 on '0' after '110'
                end
            4'b0100: // S4
                if (reset) begin
                    state <= 4'b0000; // Reset to S0 on reset
                    start_shifting <= 0;
                end else begin
                    state <= 4'b0100; // Stay in S4
                    start_shifting <= 1; // Keep start_shifting at 1
                end
        endcase
    end
end

endmodule