module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Left neighbors: shift q right by 1, boundary left neighbor is zero
    assign left_neighbors = {q[510:0], 1'b0};
    // Right neighbors: shift q left by 1, boundary right neighbor is zero
    assign right_neighbors = {1'b0, q[511:1]};

    // Next state: XOR of left and right neighbors per Rule 90
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule