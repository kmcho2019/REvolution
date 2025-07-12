module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg [2:0] en_pipe;

// Early completion detection
wire early_complete;
wire [64:0] early_result;
assign {early_result[64], early_result[63:0]} = adda + addb;
assign early_complete = (adda + addb) == early_result[63:0];

// Stage 0: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        en_pipe <= 3'b0;
    end else begin
        a_reg <= adda;
        b_reg <= addb;
        en_pipe <= {en_pipe[1:0], i_en};
    end
end

// Stage 1: Parallel prefix computation
wire [63:0] gen, prop;
wire [63:0] carry;

// Generate and propagate terms
assign gen = a_reg & b_reg;
assign prop = a_reg ^ b_reg;

// Kogge-Stone parallel prefix network
wire [63:0] gen_stage1, prop_stage1;
wire [63:0] gen_stage2, prop_stage2;
wire [63:0] gen_stage3, prop_stage3;
wire [63:0] gen_stage4, prop_stage4;
wire [63:0] gen_stage5, prop_stage5;
wire [63:0] gen_stage6, prop_stage6;

// Stage 1: 1-bit span
assign gen_stage1[0] = gen[0];
assign prop_stage1[0] = prop[0];
generate
    for (genvar i = 1; i < 64; i = i + 1) begin
        assign gen_stage1[i] = gen[i] | (prop[i] & gen[i-1]);
        assign prop_stage1[i] = prop[i] & prop[i-1];
    end
endgenerate

// Stage 2: 2-bit span
assign gen_stage2[1:0] = gen_stage1[1:0];
assign prop_stage2[1:0] = prop_stage1[1:0];
generate
    for (genvar i = 2; i < 64; i = i + 1) begin
        assign gen_stage2[i] = gen_stage1[i] | (prop_stage1[i] & gen_stage1[i-2]);
        assign prop_stage2[i] = prop_stage1[i] & prop_stage1[i-2];
    end
endgenerate

// Stage 3: 4-bit span
assign gen_stage3[3:0] = gen_stage2[3:0];
assign prop_stage3[3:0] = prop_stage2[3:0];
generate
    for (genvar i = 4; i < 64; i = i + 1) begin
        assign gen_stage3[i] = gen_stage2[i] | (prop_stage2[i] & gen_stage2[i-4]);
        assign prop_stage3[i] = prop_stage2[i] & prop_stage2[i-4];
    end
endgenerate

// Stage 4: 8-bit span
assign gen_stage4[7:0] = gen_stage3[7:0];
assign prop_stage4[7:0] = prop_stage3[7:0];
generate
    for (genvar i = 8; i < 64; i = i + 1) begin
        assign gen_stage4[i] = gen_stage3[i] | (prop_stage3[i] & gen_stage3[i-8]);
        assign prop_stage4[i] = prop_stage3[i] & prop_stage3[i-8];
    end
endgenerate

// Stage 5: 16-bit span
assign gen_stage5[15:0] = gen_stage4[15:0];
assign prop_stage5[15:0] = prop_stage4[15:0];
generate
    for (genvar i = 16; i < 64; i = i + 1) begin
        assign gen_stage5[i] = gen_stage4[i] | (prop_stage4[i] & gen_stage4[i-16]);
        assign prop_stage5[i] = prop_stage4[i] & prop_stage4[i-16];
    end
endgenerate

// Stage 6: 32-bit span
assign gen_stage6[31:0] = gen_stage5[31:0];
assign prop_stage6[31:0] = prop_stage5[31:0];
generate
    for (genvar i = 32; i < 64; i = i + 1) begin
        assign gen_stage6[i] = gen_stage5[i] | (prop_stage5[i] & gen_stage5[i-32]);
        assign prop_stage6[i] = prop_stage5[i] & prop_stage5[i-32];
    end
endgenerate

// Final carry computation
assign carry[0] = 1'b0;
generate
    for (genvar i = 1; i < 64; i = i + 1) begin
        assign carry[i] = gen_stage6[i-1];
    end
endgenerate

// Stage 2: Final sum computation
wire [64:0] final_sum;
assign final_sum[63:0] = prop ^ {carry[62:0], 1'b0};
assign final_sum[64] = gen_stage6[63];

// Output registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (en_pipe[1] && early_complete) begin
            result <= early_result;
            o_en <= 1'b1;
        end else if (en_pipe[2]) begin
            result <= final_sum;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule