module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Johnson counter implementation:
// - Reset clears all bits
// - Normal operation: shift right and insert inverted LSB as new MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end
    else begin
        Q <= {~Q[0], Q[63:1]};  // Johnson counter shift operation
    end
end

endmodule