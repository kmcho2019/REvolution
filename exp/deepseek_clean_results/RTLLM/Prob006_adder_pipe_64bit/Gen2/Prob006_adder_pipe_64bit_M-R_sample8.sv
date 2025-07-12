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
reg [63:0] adda_stg1, adda_stg2, adda_stg3;
reg [63:0] addb_stg1, addb_stg2, addb_stg3;
reg carry_stg1, carry_stg2, carry_stg3;
reg en_stg1, en_stg2, en_stg3;

// Segment sums (with carry 0 and 1)
wire [16:0] sum0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
wire [16:0] sum0_c1 = sum0 + 1'b1;

wire [16:0] sum1 = {1'b0, adda[31:16]} + {1'b0, addb[31:16]};
wire [16:0] sum1_c1 = sum1 + 1'b1;

wire [16:0] sum2 = {1'b0, adda[47:32]} + {1'b0, addb[47:32]};
wire [16:0] sum2_c1 = sum2 + 1'b1;

wire [16:0] sum3 = {1'b0, adda[63:48]} + {1'b0, addb[63:48]};
wire [16:0] sum3_c1 = sum3 + 1'b1;

// Intermediate results
wire [15:0] seg0_result = sum0[15:0];
wire seg0_carry = sum0[16];

wire [15:0] seg1_result = carry_stg1 ? sum1_c1[15:0] : sum1[15:0];
wire seg1_carry = carry_stg1 ? sum1_c1[16] : sum1[16];

wire [15:0] seg2_result = carry_stg2 ? sum2_c1[15:0] : sum2[15:0];
wire seg2_carry = carry_stg2 ? sum2_c1[16] : sum2[16];

wire [15:0] seg3_result = carry_stg3 ? sum3_c1[15:0] : sum3[15:0];
wire seg3_carry = carry_stg3 ? sum3_c1[16] : sum3[16];

// Pipeline stage 1 (bits 15:0)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_stg1 <= 64'b0;
        addb_stg1 <= 64'b0;
        carry_stg1 <= 1'b0;
        en_stg1 <= 1'b0;
    end else begin
        adda_stg1 <= adda;
        addb_stg1 <= addb;
        carry_stg1 <= seg0_carry;
        en_stg1 <= i_en;
    end
end

// Pipeline stage 2 (bits 31:16)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_stg2 <= 64'b0;
        addb_stg2 <= 64'b0;
        carry_stg2 <= 1'b0;
        en_stg2 <= 1'b0;
    end else begin
        adda_stg2 <= adda_stg1;
        addb_stg2 <= addb_stg1;
        carry_stg2 <= seg1_carry;
        en_stg2 <= en_stg1;
    end
end

// Pipeline stage 3 (bits 47:32)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_stg3 <= 64'b0;
        addb_stg3 <= 64'b0;
        carry_stg3 <= 1'b0;
        en_stg3 <= 1'b0;
    end else begin
        adda_stg3 <= adda_stg2;
        addb_stg3 <= addb_stg2;
        carry_stg3 <= seg2_carry;
        en_stg3 <= en_stg2;
    end
end

// Output stage (bits 63:48)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {seg3_carry, seg3_result, seg2_result, seg1_result, seg0_result};
        o_en <= en_stg3;
    end
end

endmodule