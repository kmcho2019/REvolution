module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [63:0] acc_reg;
    
    // Overflow detection signals
    wire overflow_pos, overflow_neg;
    
    // Enable signals for each stage
    wire stage1_en = ~rst;
    wire stage2_en = ~rst;
    
    // Calculate product (stage 1)
    wire signed [63:0] product = a_reg * b_reg;
    
    // Calculate next accumulator value (stage 2)
    wire signed [63:0] acc_next = acc_reg + product_reg;
    
    // Overflow detection
    assign overflow_pos = (acc_reg[63] == 0) && (product_reg[63] == 0) && (acc_next[63] == 1);
    assign overflow_neg = (acc_reg[63] == 1) && (product_reg[63] == 1) && (acc_next[63] == 0);
    
    // Pipeline stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            product_reg <= 0;
        end else if (stage1_en) begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= product;
        end
    end
    
    // Pipeline stage 2: Accumulation with saturation
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 0;
            c <= 0;
        end else if (stage2_en) begin
            // Handle overflow cases
            if (overflow_pos) begin
                acc_reg <= 63'h7FFFFFFFFFFFFFFF;
                c <= 32'h7FFFFFFF;
            end else if (overflow_neg) begin
                acc_reg <= 63'h8000000000000000;
                c <= 32'h80000000;
            end else begin
                acc_reg <= acc_next;
                c <= acc_next[31:0];
            end
        end
    end

endmodule