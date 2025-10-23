module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Internal wires for left and right neighbors with zero padding at boundaries
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Left neighbors:
    // q[-1] = 0, so left_neighbors[0] = 0, left_neighbors[1] = q[0], ..., left_neighbors[511] = q[510]
    assign left_neighbors = {q[510:0], 1'b0};

    // Right neighbors:
    // q[512] = 0, so right_neighbors[511] = 0, right_neighbors[0] = q[1], ..., right_neighbors[510] = q[511]
    assign right_neighbors = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors per Rule 90
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule