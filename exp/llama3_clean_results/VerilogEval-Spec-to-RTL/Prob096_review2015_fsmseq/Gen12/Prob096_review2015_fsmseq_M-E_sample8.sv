module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register

// State definition
localparam S0 = 2'b00; // Initial state
localparam S1 = 2'b01; // '1' detected
localparam S2 = 2'b10; // '11' detected
localparam S3 = 2'b11; // '110' detected
localparam S4 = 2'b00; // Sequence detected, start shifting

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            S0: begin
                if (data == 1) begin
                    state <= S1; // Transition to S1 if '1' detected
                end
            end
            S1: begin
                if (data == 1) begin
                    state <= S2; // Transition to S2 if '11' detected
                end else if (data == 0) begin
                    state <= S0; // Transition to S0 if '1' followed by '0'
                end
            end
            S2: begin
                if (data == 0) begin
                    state <= S3; // Transition to S3 if '110' detected
                end else if (data == 1) begin
                    state <= S2; // Stay in S2 if '11' followed by '1'
                end
            end
            S3: begin
                if (data == 1) begin
                    state <= S4; // Transition to S4 if sequence detected
                    start_shifting <= 1; // Set start_shifting
                end else begin
                    state <= S0; // Transition to S0 if '110' followed by '0'
                end
            end
            S4: begin
                start_shifting <= 1; // Keep start_shifting high
            end
            default: begin
                state <= S0; // Default state
            end
        endcase
    end
end

endmodule