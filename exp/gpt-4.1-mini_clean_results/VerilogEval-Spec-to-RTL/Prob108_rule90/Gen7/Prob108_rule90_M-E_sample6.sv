module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Zero boundary at left: shift right q by 1, insert zero at MSB
    assign left_neighbors  = {q[510:0], 1'b0};

    // Zero boundary at right: shift left q by 1, insert zero at LSB
    assign right_neighbors = {1'b0, q[511:1]};

    // Rule 90 next state: next cell state = XOR of neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule