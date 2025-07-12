module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// To optimize for performance, we keep the logic simple and ensure that
// the operations within the always block are minimized.
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0.
        Q <= 64'd0;
    end else begin
        // If the least significant bit (Q[0]) is 0, increment by shifting right and appending 1.
        // If Q[0] is 1, decrement by shifting right and appending 0.
        Q <= (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : {1'b0, Q[63:1]};
    end
end

endmodule