module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (4-stage)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers for operands and enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products (2 halves: mul_b_low[3:0], mul_b_high[7:4])
    reg [11:0] pp_low;   // 8x4 bit product max 12 bits (8 + 4)
    reg [11:0] pp_high;

    // Stage 3: Accumulate shifted partial products
    reg [15:0] sum_stage3;

    // Stage 4: Final registered output product
    reg [15:0] mul_out_reg;

    // Input sampling and mul_en propagation stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Partial product generation combinational function: 8x4 bits multiplication
    // Method: sum of shifted and masked bits
    function [11:0] mul8x4;
        input [7:0] a; // 8-bit multiplicand
        input [3:0] b; // 4-bit multiplier
        integer i;
        reg [11:0] product;
    begin
        product = 12'd0;
        for (i=0; i<4; i=i+1) begin
            if (b[i])
                product = product + (a << i);
        end
        mul8x4 = product;
    end
    endfunction

    // Stage 2: Partial product generation (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_low <= 12'd0;
            pp_high <= 12'd0;
        end else if (mul_en_pipe[0]) begin
            pp_low  <= mul8x4(mul_a_reg, mul_b_reg[3:0]);
            pp_high <= mul8x4(mul_a_reg, mul_b_reg[7:4]);
        end else begin
            pp_low <= 12'd0;
            pp_high <= 12'd0;
        end
    end

    // Stage 3: Accumulate partial products (shift high part by 4)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            // Shift high partial product by 4 bits and add low partial product
            sum_stage3 <= (pp_high << 4) + pp_low;
        end else begin
            sum_stage3 <= 16'd0;
        end
    end

    // Stage 4: Register final output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage3;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable is last stage of enable pipeline shift register
    assign mul_en_out = mul_en_pipe[3];

    // Output product is valid only if mul_en_out is asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule