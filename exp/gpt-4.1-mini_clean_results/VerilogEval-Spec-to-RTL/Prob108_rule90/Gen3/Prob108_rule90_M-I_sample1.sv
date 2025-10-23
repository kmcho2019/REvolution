module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Shift q left by 1 bit with zero on LSB (right boundary)
    assign left_neighbors  = {q[510:0], 1'b0};
    // Shift q right by 1 bit with zero on MSB (left boundary)
    assign right_neighbors = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule