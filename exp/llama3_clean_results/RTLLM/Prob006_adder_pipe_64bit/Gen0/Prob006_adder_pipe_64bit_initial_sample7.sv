module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg i_en_reg;
reg [63:0] sum;
reg [63:0] carry;

// Pipeline stage 1: Synchronize input enable signal and input operands
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 0;
        reg_adda <= 0;
        reg_addb <= 0;
    end else if (i_en) begin
        i_en_reg <= 1;
        reg_adda <= adda;
        reg_addb <= addb;
    end else begin
        i_en_reg <= 0;
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
    end
end

// Pipeline stage 2: Calculate sum and carry
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
        carry <= 0;
    end else if (i_en_reg) begin
        sum <= reg_adda + reg_addb;
        carry <= (reg_adda[63:32] + reg_addb[63:32] + {32{1'b0}}) > 64'd4294967295;
    end else begin
        sum <= sum;
        carry <= carry;
    end
end

// Pipeline stage 3: Calculate final result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 0;
        o_en <= 0;
    end else if (i_en_reg) begin
        result <= {carry, sum[63:0]};
        o_en <= 1;
    end else if (~i_en_reg && sum != 0) begin
        result <= result;
        o_en <= 1;
    end else begin
        result <= 0;
        o_en <= 0;
    end
end

endmodule