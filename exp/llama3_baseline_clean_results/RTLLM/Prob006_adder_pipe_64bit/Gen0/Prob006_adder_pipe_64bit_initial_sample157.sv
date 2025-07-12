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
reg [15:0] sum0, sum1, sum2, sum3;
reg carry0, carry1, carry2, carry3;
reg i_en_reg, i_en_reg1, i_en_reg2, i_en_reg3;
wire [16:0] sum_wire0, sum_wire1, sum_wire2, sum_wire3;

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'b1;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end
end

// Pipeline stage 0 (bits 0-15)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'd0;
        carry0 <= 1'b0;
        i_en_reg1 <= 1'b0;
    end else if (i_en_reg) begin
        {carry0, sum0} <= adda_reg[15:0] + addb_reg[15:0];
        i_en_reg1 <= 1'b1;
    end else begin
        sum0 <= sum0;
        carry0 <= carry0;
        i_en_reg1 <= i_en_reg1;
    end
end

// Pipeline stage 1 (bits 16-31)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 16'd0;
        carry1 <= 1'b0;
        i_en_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        {carry1, sum1} <= adda_reg[31:16] + addb_reg[31:16] + carry0;
        i_en_reg2 <= 1'b1;
    end else begin
        sum1 <= sum1;
        carry1 <= carry1;
        i_en_reg2 <= i_en_reg2;
    end
end

// Pipeline stage 2 (bits 32-47)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 16'd0;
        carry2 <= 1'b0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        {carry2, sum2} <= adda_reg[47:32] + addb_reg[47:32] + carry1;
        i_en_reg3 <= 1'b1;
    end else begin
        sum2 <= sum2;
        carry2 <= carry2;
        i_en_reg3 <= i_en_reg3;
    end
end

// Pipeline stage 3 (bits 48-63)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum3 <= 16'd0;
        carry3 <= 1'b0;
    end else if (i_en_reg3) begin
        {carry3, sum3} <= adda_reg[63:48] + addb_reg[63:48] + carry2;
    end else begin
        sum3 <= sum3;
        carry3 <= carry3;
    end
end

// Output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg3) begin
        result <= {carry3, sum3, sum2, sum1, sum0};
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= 1'b0;
    end
end

endmodule