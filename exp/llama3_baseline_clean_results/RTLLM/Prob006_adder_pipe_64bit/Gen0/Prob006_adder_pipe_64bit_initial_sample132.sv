module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// 1-bit full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Pipeline registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [63:0] sum_reg;
reg [63:0] carry_reg;

// Initialize output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 0;
    end else if (i_en_reg) begin
        o_en <= 1;
    end else begin
        o_en <= 0;
    end
end

// Pipeline stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 0;
        addb_reg <= 0;
        i_en_reg <= 0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end
end

// Pipeline stage 2: Perform addition
reg [64:0] sum;
always @(posedge clk) begin
    sum[0] = adda_reg[0] ^ addb_reg[0];
    carry_reg[0] = adda_reg[0] & addb_reg[0];
    for (int i = 1; i < 64; i++) begin
        sum[i] = adda_reg[i] ^ addb_reg[i] ^ carry_reg[i-1];
        carry_reg[i] = (adda_reg[i] & addb_reg[i]) | (adda_reg[i] & carry_reg[i-1]) | (addb_reg[i] & carry_reg[i-1]);
    end
    sum[64] = carry_reg[63];
end

// Pipeline stage 3: Register sum and carry
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 0;
    end else begin
        result <= sum;
    end
end

endmodule