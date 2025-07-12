module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_neighbor = {q[510:0], 1'b0};  // q[i+1], with q[512] = 0
    wire [511:0] right_neighbor = {1'b0, q[511:1]}; // q[i-1], with q[-1] = 0
    wire [511:0] center = q;

    // Rule 110 conditions
    wire [511:0] cond1 = left_neighbor & center & ~right_neighbor; // 110 -> 1
    wire [511:0] cond2 = left_neighbor & ~center & right_neighbor; // 101 -> 1
    wire [511:0] cond3 = ~left_neighbor & center;                  // 011/010 -> 1
    wire [511:0] cond4 = ~left_neighbor & ~center & right_neighbor;// 001 -> 1

    // Combine all conditions to get next state
    wire [511:0] next_q = cond1 | cond2 | cond3 | cond4;

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule