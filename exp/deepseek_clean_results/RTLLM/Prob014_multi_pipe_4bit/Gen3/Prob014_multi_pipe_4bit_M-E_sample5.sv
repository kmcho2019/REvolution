module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Generate all partial products
wire [15:0] pp;
genvar i, j;
generate
    for (i = 0; i < size; i = i + 1) begin : ROW
        for (j = 0; j < size; j = j + 1) begin : COL
            assign pp[i*4 + j] = mul_a[j] & mul_b[i];
        end
    end
endgenerate

// First pipeline stage: Wallace tree compression
wire [6:0] sum_stage1, carry_stage1;

// Layer 1 compression
wire s11, s12, s13, c11, c12, c13;
full_adder fa11(pp[1], pp[4], pp[5], s11, c11);
full_adder fa12(pp[2], pp[6], pp[7], s12, c12);
full_adder fa13(pp[3], pp[8], pp[9], s13, c13);

// Layer 2 compression
wire s21, s22, c21, c22;
full_adder fa21(s11, c11, pp[10], s21, c21);
full_adder fa22(s12, c12, pp[11], s22, c22);

// Layer 3 compression
wire s31, c31;
full_adder fa31(s21, c21, pp[12], s31, c31);

// Pipeline registers for compressed results
reg [6:0] sum_reg, carry_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 7'b0;
        carry_reg <= 7'b0;
    end else begin
        sum_reg <= {s31, s22, s13, pp[0]};
        carry_reg <= {c31, c22, c13, 1'b0} << 1;
    end
end

// Second pipeline stage: final addition
wire [7:0] final_sum;
assign final_sum = sum_reg + carry_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= final_sum;
    end
end

endmodule

// Full adder module for compression
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