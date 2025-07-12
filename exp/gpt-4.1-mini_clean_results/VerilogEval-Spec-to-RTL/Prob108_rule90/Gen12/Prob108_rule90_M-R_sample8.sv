module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_neighbors, right_neighbors;
    wire [511:0] next_state;

    // Left neighbors: q[-1] = 0 boundary on the left
    assign left_neighbors = {q[510:0], 1'b0};
    // Right neighbors: q[512] = 0 boundary on the right
    assign right_neighbors = {1'b0, q[511:1]};

    // Next state for each cell is XOR of left and right neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule