// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Initialize the look-up table (LUT) with pre-computed next states
reg [63:0] lut [63:0];

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // Update Q based on the value of Q[0]
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};
        end else begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

// Initialize the LUT with pre-computed next states
initial begin
    for (int i = 0; i < 64; i++) begin
        lut[i] = {1'b1, {63 - i}{1'b0}};
    end
    for (int i = 64; i < 128; i++) begin
        lut[i] = {1'b0, {63 - (i - 64)}{1'b1}};
    end
end

endmodule