module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] q_left_shift;
    wire [511:0] q_right_shift;
    wire [511:0] next_state;

    // Left neighbors: q[i-1], with q[-1]=0
    assign q_left_shift = {q[510:0], 1'b0};
    // Right neighbors: q[i+1], with q[512]=0
    assign q_right_shift = {1'b0, q[511:1]};
    // Rule 90 next state: XOR of neighbors
    assign next_state = q_left_shift ^ q_right_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule