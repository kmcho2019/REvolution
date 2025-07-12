module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Clock gating logic
wire clk_en = load || (|(q ^ {q[510:0], 1'b0})); // Enable clock when load or state changes
wire gated_clk = clk & clk_en;

// Pipeline registers
reg [511:0] next_q_stage1;
reg [511:0] next_q_stage2;

// Virtual boundary registers (optimized area)
reg left_boundary = 1'b0;
reg right_boundary = 1'b0;

// Stage 1: Calculate neighbor XOR for even and odd cells separately
always @(*) begin
    // Even cells (0, 2, 4...)
    for (integer i = 0; i < 512; i = i + 2) begin
        wire left = (i == 0) ? left_boundary : q[i-1];
        wire right = (i == 510) ? right_boundary : q[i+1];
        next_q_stage1[i] = left ^ right;
    end
    
    // Odd cells (1, 3, 5...)
    for (integer j = 1; j < 512; j = j + 2) begin
        wire left = (j == 1) ? left_boundary : q[j-1];
        wire right = (j == 511) ? right_boundary : q[j+1];
        next_q_stage1[j] = left ^ right;
    end
end

// Stage 2: Pipeline register
always @(posedge gated_clk) begin
    next_q_stage2 <= next_q_stage1;
end

// Final output register with load capability
always @(posedge gated_clk) begin
    if (load) begin
        q <= data;
        // Update virtual boundaries when loading
        left_boundary <= 1'b0;
        right_boundary <= 1'b0;
    end else begin
        q <= next_q_stage2;
    end
end

endmodule