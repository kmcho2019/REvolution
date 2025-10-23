module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg     o_en
);

// Pipeline registers for sums and carry outs
reg [15:0] sum_stage0, sum_stage1, sum_stage2, sum_stage3;
reg carry_stage0, carry_stage1, carry_stage2, carry_stage3;

// Pipeline registers for input operands and enable signals to maintain synchronization
reg [15:0] adda_stage1, addb_stage1;
reg [15:0] adda_stage2, addb_stage2;
reg [15:0] adda_stage3, addb_stage3;

reg en_stage0, en_stage1, en_stage2, en_stage3;

// Stage 0 - add bits [15:0]
wire [16:0] sum0_ext = {1'b0, adda[15:0]} + {1'b0, addb[15:0]}; // carry in = 0

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage0 <= 16'b0;
        carry_stage0 <= 1'b0;
        adda_stage1 <= 16'b0;
        addb_stage1 <= 16'b0;
        en_stage0 <= 1'b0;
    end else begin
        if (i_en) begin
            sum_stage0 <= sum0_ext[15:0];
            carry_stage0 <= sum0_ext[16];
            adda_stage1 <= adda[31:16];
            addb_stage1 <= addb[31:16];
        end
        en_stage0 <= i_en;
    end
end

// Stage 1 - add bits [31:16]
wire [16:0] sum1_ext = {1'b0, adda_stage1} + {1'b0, addb_stage1} + carry_stage0;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage1 <= 16'b0;
        carry_stage1 <= 1'b0;
        adda_stage2 <= 16'b0;
        addb_stage2 <= 16'b0;
        en_stage1 <= 1'b0;
    end else begin
        sum_stage1 <= sum1_ext[15:0];
        carry_stage1 <= sum1_ext[16];
        adda_stage2 <= adda[47:32];
        addb_stage2 <= addb[47:32];
        en_stage1 <= en_stage0;
    end
end

// Stage 2 - add bits [47:32]
wire [16:0] sum2_ext = {1'b0, adda_stage2} + {1'b0, addb_stage2} + carry_stage1;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage2 <= 16'b0;
        carry_stage2 <= 1'b0;
        adda_stage3 <= 16'b0;
        addb_stage3 <= 16'b0;
        en_stage2 <= 1'b0;
    end else begin
        sum_stage2 <= sum2_ext[15:0];
        carry_stage2 <= sum2_ext[16];
        adda_stage3 <= adda[63:48];
        addb_stage3 <= addb[63:48];
        en_stage2 <= en_stage1;
    end
end

// Stage 3 - add bits [63:48]
wire [16:0] sum3_ext = {1'b0, adda_stage3} + {1'b0, addb_stage3} + carry_stage2;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage3 <= 16'b0;
        carry_stage3 <= 1'b0;
        en_stage3 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum_stage3 <= sum3_ext[15:0];
        carry_stage3 <= sum3_ext[16];
        en_stage3 <= en_stage2;
        // Concatenate all stage sums and the final carry out
        result <= {carry_stage3, sum_stage3, sum_stage2, sum_stage1, sum_stage0};
        o_en <= en_stage3;
    end
end

endmodule