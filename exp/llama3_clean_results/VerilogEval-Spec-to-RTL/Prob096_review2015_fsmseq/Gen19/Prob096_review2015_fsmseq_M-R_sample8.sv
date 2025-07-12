module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // Current state
reg [3:0] seq_det; // Sequence detection bits

// State definition
localparam S0 = 2'b00; // Initial state
localparam S1 = 2'b01; // '1' detected
localparam S2 = 2'b10; // '11' detected
localparam S3 = 2'b11; // '110' detected

always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        seq_det <= 4'b0000; // Reset sequence detection bits
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            S0: begin
                if (data == 1) begin
                    state <= S1; // Transition to S1 if '1' detected
                    seq_det <= 4'b1000; // Set first bit of sequence
                end else begin
                    state <= S0; // Stay in S0
                    seq_det <= 4'b0000; // Reset sequence bits
                end
            end
            S1: begin
                if (data == 1) begin
                    state <= S2; // Transition to S2 if '11' detected
                    seq_det <= 4'b1100; // Set first two bits of sequence
                end else begin
                    state <= S0; // Transition back to S0 if '10' detected
                    seq_det <= 4'b0000; // Reset sequence bits
                end
            end
            S2: begin
                if (data == 0) begin
                    state <= S3; // Transition to S3 if '110' detected
                    seq_det <= 4'b0110; // Set first three bits of sequence
                end else begin
                    state <= S2; // Stay in S2 if '111' detected
                    seq_det <= 4'b1100; // Keep first two bits of sequence
                end
            end
            S3: begin
                if (data == 1) begin
                    start_shifting <= 1; // Set start_shifting if sequence '1101' detected
                end
                state <= S0; // Transition back to S0
                seq_det <= 4'b0000; // Reset sequence bits
            end
        endcase
    end
end

endmodule