module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] ext_a_stage1, ext_a_stage2;
reg [size-1:0] b_stage1, b_stage2;
reg [2*size-1:0] partial_sum;

// Stage 1: Process bits 0 and 2
wire [2*size-1:0] pp0 = b_stage1[0] ? ext_a_stage1 : 0;
wire [2*size-1:0] pp2 = b_stage1[2] ? (ext_a_stage1 << 2) : 0;
wire [2*size-1:0] stage1_sum = pp0 + pp2;

// Stage 2: Process bits 1 and 3
wire [2*size-1:0] pp1 = b_stage2[1] ? (ext_a_stage2 << 1) : 0;
wire [2*size-1:0] pp3 = b_stage2[3] ? (ext_a_stage2 << 3) : 0;
wire [2*size-1:0] stage2_sum = partial_sum + pp1 + pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        ext_a_stage1 <= 0;
        ext_a_stage2 <= 0;
        b_stage1 <= 0;
        b_stage2 <= 0;
        partial_sum <= 0;
        mul_out <= 0;
    end else begin
        // Pipeline stage 1
        ext_a_stage1 <= { {size{1'b0}}, mul_a };
        b_stage1 <= mul_b;
        
        // Pipeline stage 2
        ext_a_stage2 <= ext_a_stage1;
        b_stage2 <= b_stage1;
        partial_sum <= stage1_sum;
        
        // Output stage
        mul_out <= stage2_sum;
    end
end

endmodule