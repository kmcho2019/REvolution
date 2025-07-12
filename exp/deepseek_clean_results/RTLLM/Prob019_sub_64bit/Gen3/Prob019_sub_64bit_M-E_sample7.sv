module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow,
    input clk,
    input rst_n
);

// Pipeline registers
reg signed [63:0] A_reg, B_reg;
reg A_sign, B_sign;
reg [63:0] B_comp;  // B complement for subtraction

// Stage 1: Preprocessing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        A_reg <= 64'b0;
        B_reg <= 64'b0;
        A_sign <= 1'b0;
        B_sign <= 1'b0;
        B_comp <= 64'b0;
    end else begin
        A_reg <= A;
        B_reg <= B;
        A_sign <= A[63];
        B_sign <= B[63];
        B_comp <= ~B + 1'b1;  // Two's complement
    end
end

// Stage 2: Computation and overflow detection
wire [63:0] sum = A_reg + B_comp;
wire sum_sign = sum[63];
wire potential_pos_overflow = (~A_sign & B_sign);
wire potential_neg_overflow = (A_sign & ~B_sign);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 64'b0;
        overflow <= 1'b0;
    end else begin
        result <= sum;
        
        // Overflow detection
        if (potential_pos_overflow && sum_sign) begin
            overflow <= 1'b1;
        end
        else if (potential_neg_overflow && !sum_sign) begin
            overflow <= 1'b1;
        end
        else begin
            overflow <= 1'b0;
        end
    end
end

endmodule