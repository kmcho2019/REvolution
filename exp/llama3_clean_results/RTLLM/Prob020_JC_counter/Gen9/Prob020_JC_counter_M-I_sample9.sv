module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Simplify the combinational logic by directly updating the MSB based on the LSB
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'd0;
    end else begin
        // Update Q based on its current value, focusing on the LSB and MSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule