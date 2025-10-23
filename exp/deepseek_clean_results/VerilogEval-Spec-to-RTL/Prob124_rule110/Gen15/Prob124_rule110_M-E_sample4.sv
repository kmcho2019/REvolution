module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Boundary registers (always 0)
    reg left_boundary = 1'b0;
    reg right_boundary = 1'b0;

    // Pipeline registers
    reg [511:0] stage1_left_center;
    reg [511:0] stage1_center_right;
    reg [511:0] stage2_result;

    // Shift register with extended boundaries
    wire [513:0] extended_q = {left_boundary, q, right_boundary};

    // Stage 1: Compute neighbor pairs
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            stage1_left_center[i] = extended_q[i+2] & extended_q[i+1];  // left & center
            stage1_center_right[i] = extended_q[i+1] & extended_q[i];   // center & right
        end
    end

    // Stage 2: Compute Rule 110
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            stage2_result[i] = (~extended_q[i+2] & (extended_q[i+1] | extended_q[i])) |  // Cases where left=0
                              (extended_q[i+2] & extended_q[i+1] & ~extended_q[i]);     // 110 case
        end
    end

    // Sequential logic with pipeline
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= stage2_result;
        end
    end

endmodule