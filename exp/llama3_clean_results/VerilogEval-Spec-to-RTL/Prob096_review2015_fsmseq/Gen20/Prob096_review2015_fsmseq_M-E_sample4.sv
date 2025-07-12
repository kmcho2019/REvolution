module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register
reg [1:0] count_ones; // Counter for consecutive '1's
reg [1:0] count_zeros; // Counter for consecutive '0's

// State definition
localparam S0 = 2'b00; // Initial state
localparam S1 = 2'b01; // '1' detected
localparam S2 = 2'b10; // '11' detected
localparam S3 = 2'b11; // '110' detected

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state <= S0; // Reset state
        count_ones <= 0; // Reset count_ones
        count_zeros <= 0; // Reset count_zeros
        start_shifting <= 0; // Reset start_shifting
    end else begin
        case (state)
            S0: begin
                if (data == 1) begin
                    count_ones <= count_ones + 1; // Increment count_ones
                    if (count_ones == 2) begin
                        state <= S1; // Transition to S1 if '1' detected
                        count_ones <= 0; // Reset count_ones
                    end
                end else begin
                    count_zeros <= count_zeros + 1; // Increment count_zeros
                    if (count_zeros == 1) begin
                        state <= S0; // Stay in S0 if '0' detected
                        count_zeros <= 0; // Reset count_zeros
                    end
                end
            end
            S1: begin
                if (data == 1) begin
                    count_ones <= count_ones + 1; // Increment count_ones
                    if (count_ones == 2) begin
                        state <= S2; // Transition to S2 if '11' detected
                        count_ones <= 0; // Reset count_ones
                    end
                end else begin
                    state <= S3; // Transition to S3 if '110' detected
                    start_shifting <= 1; // Set start_shifting
                end
            end
            S2: begin
                if (data == 0) begin
                    state <= S3; // Transition to S3 if '110' detected
                    start_shifting <= 1; // Set start_shifting
                end else begin
                    count_ones <= count_ones + 1; // Increment count_ones
                    if (count_ones == 3) begin
                        state <= S1; // Transition to S1 if '1' detected
                        count_ones <= 0; // Reset count_ones
                    end
                end
            end
            S3: begin
                start_shifting <= 1; // Keep start_shifting high
            end
            default: begin
                state <= S0; // Default state
            end
        endcase
    end
end

endmodule