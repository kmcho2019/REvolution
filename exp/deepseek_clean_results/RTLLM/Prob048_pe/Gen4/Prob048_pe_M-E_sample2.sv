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
    reg signed [31:0] sum_reg, carry_reg;
    
    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] sum_next, carry_next;
    wire signed [31:0] accumulated;
    wire accum_en;
    
    // Clock gating control
    assign accum_en = (a != 0) || (b != 0) || rst;
    
    // Stage 1: Multiply
    assign product = a_reg * b_reg;
    
    // Stage 2: Carry-save accumulation
    carry_save_adder #(32) csa(
        .a(sum_reg),
        .b(carry_reg),
        .c(product_reg[31:0]),
        .sum(sum_next),
        .carry(carry_next)
    );
    
    // Final accumulation with saturation
    saturating_adder #(32) sat_add(
        .a(sum_reg),
        .b(carry_reg),
        .result(accumulated)
    );
    
    // Pipeline control
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            product_reg <= 0;
            sum_reg <= 0;
            carry_reg <= 0;
            c <= 0;
        end else begin
            // Stage 1 registers
            a_reg <= a;
            b_reg <= b;
            product_reg <= product;
            
            // Stage 2 registers
            sum_reg <= sum_next;
            carry_reg <= carry_next;
            
            // Output register with clock gating
            if (accum_en) begin
                c <= accumulated;
            end
        end
    end

endmodule

module carry_save_adder #(parameter WIDTH=32) (
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    input signed [WIDTH-1:0] c,
    output signed [WIDTH-1:0] sum,
    output signed [WIDTH-1:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule

module saturating_adder #(parameter WIDTH=32) (
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] result
);
    wire signed [WIDTH:0] extended_sum = a + b;
    
    always @(*) begin
        if (~extended_sum[WIDTH] && extended_sum[WIDTH-1]) begin
            result = {1'b0, {(WIDTH-1){1'b1}}; // Positive saturation
        end else if (extended_sum[WIDTH] && ~extended_sum[WIDTH-1]) begin
            result = {1'b1, {(WIDTH-1){1'b0}}; // Negative saturation
        end else begin
            result = extended_sum[WIDTH-1:0];
        end
    end
endmodule