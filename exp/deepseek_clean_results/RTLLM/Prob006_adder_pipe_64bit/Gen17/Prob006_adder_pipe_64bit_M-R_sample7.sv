module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers (sequential elements)
reg [15:0] a_stg1, b_stg1;
reg [15:0] a_stg2, b_stg2;
reg [15:0] a_stg3, b_stg3;
reg [15:0] a_stg4, b_stg4;
reg [3:0] en_pipeline;

// Intermediate wires (combinational logic)
wire [16:0] sum_stg1 = {1'b0, a_stg1} + {1'b0, b_stg1};
wire [16:0] sum_stg2 = {1'b0, a_stg2} + {1'b0, b_stg2} + sum_stg1[16];
wire [16:0] sum_stg3 = {1'b0, a_stg3} + {1'b0, b_stg3} + sum_stg2[16];
wire [16:0] sum_stg4 = {1'b0, a_stg4} + {1'b0, b_stg4} + sum_stg3[16];

// Stage 1: Bits [15:0]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg1 <= 16'b0;
        b_stg1 <= 16'b0;
        en_pipeline[0] <= 1'b0;
    end else begin
        a_stg1 <= adda[15:0];
        b_stg1 <= addb[15:0];
        en_pipeline[0] <= i_en;
    end
end

// Stage 2: Bits [31:16]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg2 <= 16'b0;
        b_stg2 <= 16'b0;
        en_pipeline[1] <= 1'b0;
    end else begin
        a_stg2 <= adda[31:16];
        b_stg2 <= addb[31:16];
        en_pipeline[1] <= en_pipeline[0];
    end
end

// Stage 3: Bits [47:32]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg3 <= 16'b0;
        b_stg3 <= 16'b0;
        en_pipeline[2] <= 1'b0;
    end else begin
        a_stg3 <= adda[47:32];
        b_stg3 <= addb[47:32];
        en_pipeline[2] <= en_pipeline[1];
    end
end

// Stage 4: Bits [63:48]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg4 <= 16'b0;
        b_stg4 <= 16'b0;
        en_pipeline[3] <= 1'b0;
    end else begin
        a_stg4 <= adda[63:48];
        b_stg4 <= addb[63:48];
        en_pipeline[3] <= en_pipeline[2];
    end
end

// Final result composition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum_stg4[16:0], sum_stg3[15:0], sum_stg2[15:0], sum_stg1[15:0]};
        o_en <= en_pipeline[3];
    end
end

endmodule