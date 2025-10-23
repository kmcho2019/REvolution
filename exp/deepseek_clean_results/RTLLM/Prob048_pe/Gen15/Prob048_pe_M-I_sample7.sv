module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals
    reg signed [31:0] acc_reg;
    wire signed [31:0] product_lsb, product_msb;
    wire signed [31:0] stage1_out;
    wire signed [31:0] final_product;
    wire signed [31:0] next_acc;
    wire clk_en;
    
    // Clock gating control
    assign clk_en = (a != 0) || (b != 0) || rst;
    
    // Pipeline stage 1: Partial product generation
    reg signed [31:0] a_reg, b_reg;
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else if (clk_en) begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Pipeline stage 2: Final addition (using carry-save)
    assign product_lsb = a_reg[15:0] * b_reg[15:0];
    assign product_msb = (a_reg[31:16] * b_reg[15:0]) + 
                       (a_reg[15:0] * b_reg[31:16]);
    assign final_product = {product_msb, 16'b0} + product_lsb;
    
    // Operand isolation during reset
    wire signed [31:0] masked_product;
    assign masked_product = rst ? 32'd0 : final_product;
    
    // Carry-save accumulation
    wire [32:0] sum_with_carry;
    assign sum_with_carry = {1'b0, acc_reg} + {1'b0, masked_product};
    assign next_acc = sum_with_carry[31:0];
    
    // Clock-gated accumulator
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'd0;
        end else if (clk_en) begin
            acc_reg <= next_acc;
        end
    end
    
    // Output assignment
    assign c = acc_reg;

endmodule