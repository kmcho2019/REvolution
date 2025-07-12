module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [1:0] state; // State machine state (S0 to S3)
reg start_shifting_reg; // Register for start_shifting signal

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state machine to S0
        start_shifting_reg <= 0; // Reset start_shifting signal
    end else begin
        case (state)
            2'b00: // S0
                if (data == 1'b1) begin
                    state <= 2'b01; // Transition to S1
                end
            2'b01: // S1
                if (data == 1'b1) begin
                    state <= 2'b10; // Transition to S2
                end else begin
                    state <= 2'b00; // Reset to S0
                end
            2'b10: // S2
                if (data == 1'b0) begin
                    state <= 2'b11; // Transition to S3
                end else begin
                    state <= 2'b01; // Reset to S1
                end
            2'b11: // S3
                if (data == 1'b1) begin
                    state <= 2'b11; // Stay in S3 and set start_shifting
                    start_shifting_reg <= 1;
                end else begin
                    state <= 2'b00; // Reset to S0
                end
            default: state <= 2'b00; // Default to S0
        endcase
    end
end

assign start_shifting = start_shifting_reg; // Drive start_shifting from register

endmodule