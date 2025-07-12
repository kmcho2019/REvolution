module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pad with zero at boundaries by shifting and masking
    wire [511:0] left  = {q[510:0], 1'b0};  // left neighbor; q[-1] assumed 0
    wire [511:0] right = {1'b0, q[511:1]};  // right neighbor; q[512] assumed 0
    wire [511:0] center = q;

    // Compute next state vectorized for all bits:
    // Rule 110 next state: next = (~left & center) | (center ^ right);
    wire [511:0] next_state = ((~left) & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule