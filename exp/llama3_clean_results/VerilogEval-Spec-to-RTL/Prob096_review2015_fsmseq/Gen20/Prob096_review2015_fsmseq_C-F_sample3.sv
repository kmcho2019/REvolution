module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Current state
reg detected; // Flag to indicate sequence detection

// State definition
localparam S0 = 2'b00; // Initial state
localparam S1 = 2'b01; // '1' detected
localparam S2 = 2'b10; // '11' detected
localparam S3 = 2'b11; // '110' detected

always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        detected <= 0; // Reset detection flag
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            S0: state <= data? S1 : S0;
            S1: state <= data? S2 : S0;
            S2: state <= ~data? S3 : S2;
            S3: begin
                if (data) begin
                    detected <= 1; // Set detection flag
                    start_shifting <= 1; // Set start_shifting
                end
                state <= S0; // Transition back to S0
            end
        endcase
        if (detected) begin
            state <= S0; // Stay in initial state after detection
        end
    end
end

endmodule