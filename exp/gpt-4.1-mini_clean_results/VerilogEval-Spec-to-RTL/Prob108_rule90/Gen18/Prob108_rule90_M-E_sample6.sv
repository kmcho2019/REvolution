module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Left neighbors: shift right by 1, insert 0 at MSB (left boundary = 0)
    assign left_neighbors = {1'b0, q[511:1]};
    // Right neighbors: shift left by 1, insert 0 at LSB (right boundary = 0)
    assign right_neighbors = {q[510:0], 1'b0};
    // Next state = XOR of left and right neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule