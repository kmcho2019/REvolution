module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] state; // 4-bit one-hot state register

// State definition
localparam S0 = 4'b0001; // Initial state
localparam S1 = 4'b0010; // '1' detected
localparam S2 = 4'b0100; // '11' detected
localparam S3 = 4'b1000; // '110' detected

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (1'b1)
            state[0]: begin // S0
                if (data == 1) begin
                    state <= S1; // Transition to S1 if '1' detected
                end else begin
                    state <= S0; // Stay in S0 if '0' detected
                end
            end
            state[1]: begin // S1
                if (data == 1) begin
                    state <= S2; // Transition to S2 if '11' detected
                end else if (data == 0) begin
                    state <= S0; // Transition to S0 if '1' followed by '0'
                end
            end
            state[2]: begin // S2
                if (data == 0) begin
                    state <= S3; // Transition to S3 if '110' detected
                end else if (data == 1) begin
                    state <= S2; // Stay in S2 if '11' followed by '1'
                end
            end
            state[3]: begin // S3
                if (data == 1) begin
                    state <= S3; // Stay in S3 if sequence detected
                    start_shifting <= 1; // Set start_shifting
                end else begin
                    state <= S0; // Transition to S0 if '110' followed by '0'
                end
            end
        endcase
    end
end

endmodule