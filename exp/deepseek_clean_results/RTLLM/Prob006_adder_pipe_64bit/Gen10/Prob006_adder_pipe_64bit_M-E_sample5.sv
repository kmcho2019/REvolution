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
reg [63:0] stage3_a, stage3_b;
reg [3:0] en_pipe;

// Early detection signals
wire early_complete;
wire [63:0] early_sum;
wire early_carry;

// Stage 1: Input registration and early detection
assign {early_carry, early_sum} = adda + addb;
assign early_complete = (adda + addb) == early_sum; // No carry propagation

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en_pipe <= 4'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en_pipe <= {en_pipe[2:0], i_en};
    end
end

// Stage 2: Carry-select block computation (8-bit blocks)
wire [7:0] carry_in_select;
wire [63:0] sum_select_0; // Sum assuming carry-in 0
wire [63:0] sum_select_1; // Sum assuming carry-in 1
wire [7:0] carry_out_0, carry_out_1;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: CS_BLOCK
        // Compute both possible sums (carry 0 and 1)
        if (i == 0) begin
            assign {carry_out_0[i], sum_select_0[i*8 +:8]} = stage1_a[i*8 +:8] + stage1_b[i*8 +:8];
            assign {carry_out_1[i], sum_select_1[i*8 +:8]} = stage1_a[i*8 +:8] + stage1_b[i*8 +:8] + 1'b1;
        end else begin
            assign {carry_out_0[i], sum_select_0[i*8 +:8]} = stage1_a[i*8 +:8] + stage1_b[i*8 +:8] + carry_in_select[i-1];
            assign {carry_out_1[i], sum_select_1[i*8 +:8]} = stage1_a[i*8 +:8] + stage1_b[i*8 +:8] + carry_in_select[i-1] + 1'b1;
        end
    end
endgenerate

// Stage 2 registers
reg [63:0] stage2_sum0, stage2_sum1;
reg [7:0] stage2_carry0, stage2_carry1;
reg early_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum0 <= 64'b0;
        stage2_sum1 <= 64'b0;
        stage2_carry0 <= 8'b0;
        stage2_carry1 <= 8'b0;
        stage2_a <= 64'b0;
        stage2_b <= 64'b0;
        early_stage2 <= 1'b0;
    end else begin
        stage2_sum0 <= sum_select_0;
        stage2_sum1 <= sum_select_1;
        stage2_carry0 <= carry_out_0;
        stage2_carry1 <= carry_out_1;
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        early_stage2 <= early_complete;
    end
end

// Stage 3: Carry resolution
wire [7:0] final_carry;
assign carry_in_select[0] = 1'b0; // Initial carry-in

generate
    for (i = 1; i < 8; i = i + 1) begin: CARRY_SELECT
        // Select correct carry based on previous block
        assign carry_in_select[i] = (final_carry[i-1]) ? stage2_carry1[i-1] : stage2_carry0[i-1];
    end
endgenerate

// Stage 3 registers
reg [63:0] stage3_sum;
reg [7:0] stage3_carry;
reg early_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 64'b0;
        stage3_carry <= 8'b0;
        stage3_a <= 64'b0;
        stage3_b <= 64'b0;
        early_stage3 <= 1'b0;
    end else begin
        // Select correct sum based on carry
        for (integer j = 0; j < 8; j = j + 1) begin
            stage3_sum[j*8 +:8] <= (carry_in_select[j]) ? stage2_sum1[j*8 +:8] : stage2_sum0[j*8 +:8];
        end
        stage3_carry <= carry_in_select;
        stage3_a <= stage2_a;
        stage3_b <= stage2_b;
        early_stage3 <= early_stage2;
    end
end

// Stage 4: Final result assembly
wire [64:0] final_result;
assign final_result = {stage3_carry[7], stage3_sum};

// Output registration with early completion
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (early_stage3) begin
            // Early completion path
            result <= {early_carry, early_sum};
        end else begin
            // Normal pipeline path
            result <= final_result;
        end
        o_en <= en_pipe[3] || (early_stage3 && en_pipe[1]);
    end
end

endmodule