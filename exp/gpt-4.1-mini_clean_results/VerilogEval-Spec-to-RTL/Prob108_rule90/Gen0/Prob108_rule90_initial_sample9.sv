module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational logic to compute next state
    wire [511:0] next_q;

    // Left neighbors: q shifted right by 1, left neighbor of q[0] is 0
    wire [511:0] left_neighbors = {q[510:0], 1'b0};
    // Right neighbors: q shifted left by 1, right neighbor of q[511] is 0
    wire [511:0] right_neighbors = {1'b0, q[511:1]};

    assign next_q = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule