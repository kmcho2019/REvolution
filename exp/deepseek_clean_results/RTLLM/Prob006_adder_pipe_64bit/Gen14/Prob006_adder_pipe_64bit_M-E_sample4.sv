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
reg [15:0] a_stg1, b_stg1;
reg [15:0] a_stg2, b_stg2;
reg [15:0] a_stg3, b_stg3;
reg [15:0] a_stg4, b_stg4;
reg [16:0] sum_stg1, sum_stg2, sum_stg3, sum_stg4;
reg [3:0] en_pipeline;

// Carry-select calculations
wire [16:0] sum1_c0 = {1'b0, a_stg1} + {1'b0, b_stg1};
wire [16:0] sum1_c1 = {1'b0, a_stg1} + {1'b0, b_stg1} + 1'b1;

wire [16:0] sum2_c0 = {1'b0, a_stg2} + {1'b0, b_stg2};
wire [16:0] sum2_c1 = {1'b0, a_stg2} + {1'b0, b_stg2} + 1'b1;

wire [16:0] sum3_c0 = {1'b0, a_stg3} + {1'b0, b_stg3};
wire [16:0] sum3_c1 = {1'b0, a_stg3} + {1'b0, b_stg3} + 1'b1;

wire [16:0] sum4_c0 = {1'b0, a_stg4} + {1'b0, b_stg4};
wire [16:0] sum4_c1 = {1'b0, a_stg4} + {1'b0, b_stg4} + 1'b1;

// Pipeline stage 1 (LSB 16 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg1 <= 0;
        b_stg1 <= 0;
        sum_stg1 <= 0;
        en_pipeline[0] <= 0;
    end else begin
        a_stg1 <= adda[15:0];
        b_stg1 <= addb[15:0];
        sum_stg1 <= sum1_c0;  // No carry-in for first stage
        en_pipeline[0] <= i_en;
    end
end

// Pipeline stage 2 (bits 16-31)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg2 <= 0;
        b_stg2 <= 0;
        sum_stg2 <= 0;
        en_pipeline[1] <= 0;
    end else begin
        a_stg2 <= adda[31:16];
        b_stg2 <= addb[31:16];
        sum_stg2 <= sum_stg1[16] ? sum2_c1 : sum2_c0;
        en_pipeline[1] <= en_pipeline[0];
    end
end

// Pipeline stage 3 (bits 32-47)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg3 <= 0;
        b_stg3 <= 0;
        sum_stg3 <= 0;
        en_pipeline[2] <= 0;
    end else begin
        a_stg3 <= adda[47:32];
        b_stg3 <= addb[47:32];
        sum_stg3 <= sum_stg2[16] ? sum3_c1 : sum3_c0;
        en_pipeline[2] <= en_pipeline[1];
    end
end

// Pipeline stage 4 (MSB 16 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg4 <= 0;
        b_stg4 <= 0;
        sum_stg4 <= 0;
        en_pipeline[3] <= 0;
    end else begin
        a_stg4 <= adda[63:48];
        b_stg4 <= addb[63:48];
        sum_stg4 <= sum_stg3[16] ? sum4_c1 : sum4_c0;
        en_pipeline[3] <= en_pipeline[2];
    end
end

// Final result composition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= {sum_stg4[16:0], sum_stg3[15:0], 
                  sum_stg2[15:0], sum_stg1[15:0]};
        o_en <= en_pipeline[3];
    end
end

endmodule