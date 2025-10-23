module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_left, q_right;
    wire [511:0] q_next;

    // Create shifted versions for neighbors
    assign q_left = {q[510:0], 1'b0};  // Left neighbors (right shift)
    assign q_right = {1'b0, q[511:1]}; // Right neighbors (left shift)

    // Compute next state (XOR of neighbors)
    assign q_next = q_left ^ q_right;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule