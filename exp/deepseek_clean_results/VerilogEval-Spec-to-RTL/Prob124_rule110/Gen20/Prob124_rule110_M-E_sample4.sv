module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Circular buffer approach for boundary handling
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Pipeline registers
    reg [511:0] stage1_and_left_center;
    reg [511:0] stage1_and_center_right;
    reg [511:0] stage2_next_q;

    // Stage 1: Compute pairwise ANDs
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            stage1_and_left_center[i] = extended_q[i+2] & extended_q[i+1];
            stage1_and_center_right[i] = extended_q[i+1] & extended_q[i];
        end
    end

    // Stage 2: Combine results
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            stage2_next_q[i] = (extended_q[i+1] ^ stage1_and_left_center[i]) | 
                              (~extended_q[i+2] & extended_q[i]);
        end
    end

    // Clock gating logic
    wire [511:0] next_q;
    assign next_q = (load) ? data : stage2_next_q;

    // State update with clock gating
    always @(posedge clk) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            if (next_q[i] != q[i]) begin
                q[i] <= next_q[i];
            end
        end
    end

endmodule