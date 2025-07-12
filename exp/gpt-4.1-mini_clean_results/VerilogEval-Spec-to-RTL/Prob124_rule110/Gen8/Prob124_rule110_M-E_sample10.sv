module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_neighbor;
    wire [511:0] right_neighbor;
    wire [511:0] center;

    // Boundary conditions: q[-1] = 0 and q[512] = 0
    // left_neighbor[i] = q[i+1] if i < 511 else 0
    // right_neighbor[i] = q[i-1] if i > 0 else 0

    assign left_neighbor  = {q[510:0], 1'b0};  // shift left by 1 bit, LSB zero padded
    assign right_neighbor = {1'b0, q[511:1]};  // shift right by 1 bit, MSB zero padded
    assign center = q;

    // Rule 110 next state logic vectorized:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left_neighbor & center) | (center ^ right_neighbor);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule