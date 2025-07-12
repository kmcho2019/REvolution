module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [15:0] sum1;
reg [15:0] sum2;
reg [15:0] sum3;
reg [15:0] sum4;
reg [16:0] sum4_ext;
reg [64:0] result_reg;
reg o_en_reg;
reg [15:0] carry1;
reg [15:0] carry2;
reg [15:0] carry3;

// Input register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end
end

// Stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 16'd0;
        carry1 <= 1'd0;
    end else if (i_en_reg) begin
        {carry1, sum1} <= adda_reg[15:0] + addb_reg[15:0];
    end
end

// Stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 16'd0;
        carry2 <= 1'd0;
    end else if (i_en_reg) begin
        {carry2, sum2} <= adda_reg[31:16] + addb_reg[31:16] + {{15{carry1[0]}}, carry1[0]};
    end
end

// Stage 3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum3 <= 16'd0;
        carry3 <= 1'd0;
    end else if (i_en_reg) begin
        {carry3, sum3} <= adda_reg[47:32] + addb_reg[47:32] + {{15{carry2[0]}}, carry2[0]};
    end
end

// Stage 4
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum4 <= 16'd0;
    end else if (i_en_reg) begin
        {sum4_ext[16], sum4} <= adda_reg[63:48] + addb_reg[63:48] + {{15{carry3[0]}}, carry3[0]};
    end
end

// Output register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        result_reg <= {sum4_ext[16], {sum4, sum3, sum2, sum1}};
        o_en_reg <= i_en_reg;
    end else begin
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule