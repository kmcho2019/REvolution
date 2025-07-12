module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Calculate next state using shift registers and bitwise XOR
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        // Handle boundaries by shifting and XORing
        // Left boundary: Shift right by 1 and fill leftmost bit with 0
        // Right boundary: Shift left by 1 and fill rightmost bit with 0
        reg [511:0] left_neighbors, right_neighbors;
        left_neighbors = {1'b0, q_reg[511:1]}; // Shift right, fill left with 0
        right_neighbors = {q_reg[510:0], 1'b0}; // Shift left, fill right with 0
        q_reg <= q_reg ^ left_neighbors ^ right_neighbors; // Update with calculated next states
    end
end

assign q = q_reg; // Output the current state

endmodule