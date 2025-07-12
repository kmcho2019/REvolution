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
reg en_reg;

// Generate and propagate terms
wire [63:0] gen = a_reg & b_reg;
wire [63:0] prop = a_reg ^ b_reg;

// Brent-Kung parallel prefix network
wire [63:0] carry;

// Prefix tree nodes
wire [63:0] gen_1, prop_1;
wire [63:0] gen_2, prop_2;
wire [63:0] gen_3, prop_3;
wire [63:0] gen_4, prop_4;

// First stage: 1-bit span
assign gen_1[0] = gen[0];
assign prop_1[0] = prop[0];
generate
    for (genvar i = 1; i < 64; i = i + 1) begin
        assign gen_1[i] = gen[i] | (prop[i] & gen[i-1]);
        assign prop_1[i] = prop[i] & prop[i-1];
    end
endgenerate

// Second stage: 2-bit span
assign gen_2[1:0] = gen_1[1:0];
assign prop_2[1:0] = prop_1[1:0];
generate
    for (genvar i = 2; i < 64; i = i + 1) begin
        assign gen_2[i] = gen_1[i] | (prop_1[i] & gen_1[i-2]);
        assign prop_2[i] = prop_1[i] & prop_1[i-2];
    end
endgenerate

// Third stage: 4-bit span
assign gen_3[3:0] = gen_2[3:0];
assign prop_3[3:0] = prop_2[3:0];
generate
    for (genvar i = 4; i < 64; i = i + 1) begin
        assign gen_3[i] = gen_2[i] | (prop_2[i] & gen_2[i-4]);
        assign prop_3[i] = prop_2[i] & prop_2[i-4];
    end
endgenerate

// Fourth stage: 8-bit span
assign gen_4[7:0] = gen_3[7:0];
assign prop_4[7:0] = prop_3[7:0];
generate
    for (genvar i = 8; i < 64; i = i + 1) begin
        assign gen_4[i] = gen_3[i] | (prop_3[i] & gen_3[i-8]);
        assign prop_4[i] = prop_3[i] & prop_3[i-8];
    end
endgenerate

// Final carry computation
assign carry[0] = 1'b0;
generate
    for (genvar i = 1; i < 64; i = i + 1) begin
        assign carry[i] = gen_4[i-1];
    end
endgenerate

// Sum computation
wire [64:0] sum;
assign sum[63:0] = prop ^ {carry[62:0], 1'b0};
assign sum[64] = gen_4[63];

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        en_reg <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registration
        a_reg <= adda;
        b_reg <= addb;
        en_reg <= i_en;
        
        // Stage 1: Output registration
        if (en_reg) begin
            result <= sum;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule