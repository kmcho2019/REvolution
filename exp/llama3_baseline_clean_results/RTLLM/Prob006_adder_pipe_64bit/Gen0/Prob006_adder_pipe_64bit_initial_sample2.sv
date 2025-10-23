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
reg reg_i_en;
reg [64:0] sum;
reg [64:0] reg_sum;
reg reg_o_en;

// Input register stage
always @(posedge clk or negedge rst_n) begin
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

// Addition stage
always @(*) begin
    reg [63:0] a;
    reg [63:0] b;
    reg [64:0] carry;
    reg [64:0] temp_sum;
    
    a = reg_adda;
    b = reg_addb;
    carry = 1'b0;
    temp_sum = 65'd0;
    
    for (int i = 0; i < 64; i++) begin
        temp_sum[i] = a[i] ^ b[i] ^ carry;
        carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
    end
    
    temp_sum[64] = carry;
    sum = temp_sum;
end

// Output register stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 65'd0;
        reg_o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_sum <= sum;
        reg_o_en <= reg_i_en;
    end else begin
        reg_sum <= reg_sum;
        reg_o_en <= reg_o_en;
    end
end

assign result = reg_sum;
assign o_en = reg_o_en;

endmodule