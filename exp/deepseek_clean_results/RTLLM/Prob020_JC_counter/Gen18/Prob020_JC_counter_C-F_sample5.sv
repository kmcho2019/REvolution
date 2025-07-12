module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Johnson counter implementation:
// - On reset: clears to all 0s
// - Normal operation: right shift with inverted LSB as new MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= 64'b0;          // Active-low async reset
    else        Q <= {~Q[0], Q[63:1]}; // Shift right with inverted LSB
end

endmodule