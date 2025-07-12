module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [63:0] stage1_a, stage1_b;
reg [63:0] stage2_a, stage2_b;
reg [2:0] en_pipe;

// Stage 1: Input registration and initial carry computation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en_pipe <= 3'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en_pipe <= {en_pipe[1:0], i_en};
    end
end

// Stage 2: 8-bit slice computation with carry-skip
wire [7:0] carry_chain;
wire [63:0] slice_sums;
wire [7:0] skip_flags;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: SLICE
        // 8-bit ripple-carry adder slices
        wire [7:0] sum;
        wire cout;
        
        if (i == 0) begin
            // First slice gets carry-in = 0
            assign {cout, sum} = stage1_a[7:0] + stage1_b[7:0];
        end else begin
            // Subsequent slices get carry from previous
            assign {cout, sum} = stage1_a[i*8 +: 8] + stage1_b[i*8 +: 8] + carry_chain[i-1];
        end
        
        assign carry_chain[i] = cout;
        assign slice_sums[i*8 +: 8] = sum;
        
        // Carry-skip condition (when all bits propagate)
        assign skip_flags[i] = &(stage1_a[i*8 +: 8] | stage1_b[i*8 +: 8]);
    end
endgenerate

// Stage 2 registers
reg [63:0] stage2_sums;
reg [7:0] stage2_carry;
reg [7:0] stage2_skip;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sums <= 64'b0;
        stage2_carry <= 8'b0;
        stage2_skip <= 8'b0;
        stage2_a <= 64'b0;
        stage2_b <= 64'b0;
    end else begin
        stage2_sums <= slice_sums;
        stage2_carry <= carry_chain;
        stage2_skip <= skip_flags;
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
    end
end

// Stage 3: Carry resolution and final sum
wire [7:0] final_carry;
assign final_carry[0] = stage2_carry[0];

generate
    for (i = 1; i < 8; i = i + 1) begin: CARRY_RESOLVE
        // Hierarchical carry resolution with skip
        assign final_carry[i] = stage2_skip[i] ? final_carry[i-1] : stage2_carry[i];
    end
endgenerate

// Final output registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Reconstruct final sum with correct carries
        result <= {1'b0, stage2_sums} + {56'b0, final_carry[7], 48'b0, final_carry[6], 40'b0, 
                 final_carry[5], 32'b0, final_carry[4], 24'b0, final_carry[3], 
                 16'b0, final_carry[2], 8'b0, final_carry[1], final_carry[0]};
        o_en <= en_pipe[2];
    end
end

endmodule