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
reg [63:0] reg_sum;
reg [63:0] reg_carry;
reg o_en_reg;

// Pipeline stage 1: Store input operands
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
    end
end

// Pipeline stage 2: Calculate sum and carry
wire [63:0] sum;
wire [63:0] carry;
assign sum[0] = reg_adda[0] ^ reg_addb[0];
assign carry[0] = reg_adda[0] & reg_addb[0];
for (genvar i = 1; i < 64; i++) begin
    assign sum[i] = reg_adda[i] ^ reg_addb[i] ^ carry[i-1];
    assign carry[i] = (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & carry[i-1]) | (reg_addb[i] & carry[i-1]);
end

// Pipeline stage 3: Store sum and carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
    end else begin
        reg_sum <= sum;
        reg_carry <= carry;
    end
end

// Pipeline stage 4: Update output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Output logic
assign result = {1'b0, reg_sum} + {64{reg_carry[63]}};
assign o_en = o_en_reg;

endmodule