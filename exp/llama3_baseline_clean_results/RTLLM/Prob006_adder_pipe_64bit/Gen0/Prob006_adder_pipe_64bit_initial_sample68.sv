module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg reg_i_en;

reg [63:0] sum;
reg carry;

// Pipeline stage 1: Register input operands and enable signal
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end else begin
        reg_adda <= reg_adda;
        reg_addb <= reg_addb;
        reg_i_en <= reg_i_en;
    end
end

// 64-bit Ripple Carry Adder
always @ (*) begin
    reg [63:0] temp_sum;
    reg [63:0] temp_carry;
    temp_sum[0] = reg_adda[0] ^ reg_addb[0];
    temp_carry[0] = reg_adda[0] & reg_addb[0];
    for (int i = 1; i < 64; i++) begin
        temp_sum[i] = reg_adda[i] ^ reg_addb[i] ^ temp_carry[i-1];
        temp_carry[i] = (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & temp_carry[i-1]) | (reg_addb[i] & temp_carry[i-1]);
    end
    sum = temp_sum;
    carry = temp_carry[63];
end

// Pipeline stage 2: Register the sum and carry
reg [64:0] reg_sum;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 65'd0;
    end else if (reg_i_en) begin
        reg_sum <= {carry, sum};
    end else begin
        reg_sum <= reg_sum;
    end
end

// Output stage: Update result and o_en
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (reg_i_en) begin
        result <= reg_sum;
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= 1'b0;
    end
end

endmodule