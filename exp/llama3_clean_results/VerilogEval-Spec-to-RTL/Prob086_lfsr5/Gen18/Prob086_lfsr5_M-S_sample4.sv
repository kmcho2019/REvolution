module TopModule #(
    parameter int WIDTH = 5,
    parameter int TAP1 = 4, // Interpretation of position 5 in 0-based indexing
    parameter int TAP2 = 2  // Interpretation of position 3 in 0-based indexing
)(
    input clk,
    input reset,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset to a known non-zero state (e.g., 1 followed by zeros)
        q <= {1'b1, {WIDTH-1{1'b0}}};
    end else begin
        // Update the state by shifting right and filling the MSB with the next state bit
        q <= {q[0] ^ q[TAP1] ^ q[TAP2], q[WIDTH-1:1]};
    end
end

endmodule