module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Encoding for states S0 to S3

always @(posedge clk) begin
    if (reset) begin // Active high synchronous reset
        state <= 0; // Reset to initial state S0
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // State S0
                if (data) begin
                    state <= 1; // Transition to S1 on '1'
                end else begin
                    state <= 0; // Stay in S0 on '0'
                end
            end
            1: begin // State S1
                if (data) begin
                    state <= 2; // Transition to S2 on '1'
                end else begin
                    state <= 0; // Reset to S0 on '0'
                end
            end
            2: begin // State S2
                if (!data) begin
                    state <= 3; // Transition to S3 on '0'
                end else begin
                    state <= 1; // Go back to S1 on '1'
                end
            end
            3: begin // State S3
                if (data) begin
                    state <= 3; // Set start_shifting, stay in this state
                    start_shifting <= 1;
                end else begin
                    state <= 0; // Reset sequence on '0'
                end
            end
            default: state <= 0; // Default to S0 for any other state
        endcase
    end
end

endmodule