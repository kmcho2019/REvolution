module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1_left_center;
    reg [511:0] stage1_center_right;
    reg [511:0] stage2_q;

    // Boundary registers (constant 0)
    wire left_boundary = 1'b0;
    wire right_boundary = 1'b0;

    // Clock gating for load path
    wire gated_clk = clk & (~load);

    // Stage 1: Calculate neighbor pairs
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Left + Center pairs (q[i+1] + q[i])
            stage1_left_center[511:1] <= {q[510:0], left_boundary} & q[511:0];
            stage1_left_center[0] <= left_boundary & q[0];

            // Center + Right pairs (q[i] + q[i-1])
            stage1_center_right[511:0] <= q[511:0] & {right_boundary, q[511:1]};
        end
    end

    // Stage 2: Rule 110 logic (pipelined)
    always @(posedge gated_clk) begin
        // Rule 110: next = (center ^ (left & right)) | (~left & right)
        // Using pre-computed pairs from stage1
        stage2_q <= (q ^ stage1_left_center) | (~stage1_left_center & stage1_center_right);
        q <= stage2_q;
    end

endmodule