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

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            S0: state <= data? S1 : S0;
            S1: state <= data? S2 : S0;
            S2: state <= data? S2 : S3;
            S3: begin
                start_shifting <= 1; // Set start_shifting if sequence detected
                state <= S0; // Transition back to S0
            end
            default: state <= S0; // Default state
        endcase
    end
end

endmodule