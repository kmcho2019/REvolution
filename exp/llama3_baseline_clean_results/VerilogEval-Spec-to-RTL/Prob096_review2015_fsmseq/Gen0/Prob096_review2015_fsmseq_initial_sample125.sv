module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Using two bits to represent four states

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to initial state (S0)
        start_shifting <= 0;
    end else begin
        case (state)
            0: // S0
                if (data) begin
                    state <= 1; // Matched first '1', move to S1
                end
            1: // S1
                if (data) begin
                    state <= 2; // Matched second '1', move to S2
                end else begin
                    state <= 0; // Didn't match, reset to S0
                end
            2: // S2
                if (!data) begin
                    state <= 3; // Matched '0', move to S3
                end else begin
                    state <= 1; // Matched another '1', move back to S1
                end
            3: // S3
                if (data) begin
                    state <= 3; // Full sequence matched, stay in S4 (state 3)
                    start_shifting <= 1;
                end else begin
                    state <= 0; // Didn't match, reset to S0
                end
            default: // Already in S4 (state 3), just maintain start_shifting = 1
                start_shifting <= 1;
        endcase
    end
end

endmodule