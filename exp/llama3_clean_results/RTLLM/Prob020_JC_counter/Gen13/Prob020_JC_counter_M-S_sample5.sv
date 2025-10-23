module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= 0; // Reset condition
    else Q <= {Q[0] ? 0 : 1, Q[63:1]}; // Update Q based on its least significant bit
end

endmodule