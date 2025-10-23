// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= {Q[0]? 0 : 1, Q[63:1]};
    end
end

endmodule