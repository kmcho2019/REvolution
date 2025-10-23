module adder_pipe_64bit(
    input clk, 
    input rst_n, 
    input i_en, 
    input [63:0] adda, 
    input [63:0] addb, 
    output [64:0] result, 
    output o_en
);

// Pipeline stage 1: Input stage
reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg i_en_reg1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
    end
end

// Pipeline stage 2: Calculate sum and carry for bits 0-15
reg [15:0] sum_reg2;
reg [15:0] carry_reg2;
reg i_en_reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg2 <= 16'd0;
        carry_reg2 <= 16'd0;
        i_en_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        {carry_reg2, sum_reg2} <= adda_reg1[15:0] + addb_reg1[15:0];
        i_en_reg2 <= i_en_reg1;
    end
end

// Pipeline stage 3: Calculate sum and carry for bits 16-31
reg [15:0] sum_reg3;
reg [15:0] carry_reg3;
reg i_en_reg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg3 <= 16'd0;
        carry_reg3 <= 16'd0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        {carry_reg3, sum_reg3} <= adda_reg1[31:16] + addb_reg1[31:16] + {16'd0, carry_reg2[15]};
        i_en_reg3 <= i_en_reg2;
    end
end

// Pipeline stage 4: Calculate sum and carry for bits 32-47
reg [15:0] sum_reg4;
reg [15:0] carry_reg4;
reg i_en_reg4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg4 <= 16'd0;
        carry_reg4 <= 16'd0;
        i_en_reg4 <= 1'b0;
    end else if (i_en_reg3) begin
        {carry_reg4, sum_reg4} <= adda_reg1[47:32] + addb_reg1[47:32] + {16'd0, carry_reg3[15]};
        i_en_reg4 <= i_en_reg3;
    end
end

// Pipeline stage 5: Calculate sum and carry for bits 48-63
reg [15:0] sum_reg5;
reg [15:0] carry_reg5;
reg i_en_reg5;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg5 <= 16'd0;
        carry_reg5 <= 16'd0;
        i_en_reg5 <= 1'b0;
    end else if (i_en_reg4) begin
        {carry_reg5, sum_reg5} <= adda_reg1[63:48] + addb_reg1[63:48] + {16'd0, carry_reg4[15]};
        i_en_reg5 <= i_en_reg4;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg5) begin
        result <= {carry_reg5[15], {sum_reg5, sum_reg4, sum_reg3, sum_reg2}};
        o_en <= i_en_reg5;
    end
end

endmodule