module pe (
    input wire clk,
    input wire rst,
    input wire valid,  // Operand isolation control
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c,
    output wire overflow  // Overflow indicator
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg valid_reg;

    // Booth encoded partial products
    wire signed [63:0] partial_products [15:0];
    wire signed [63:0] sum_stage1;

    // Clock gating
    wire clk_gated = clk & (valid | valid_reg);

    // Overflow detection
    wire signed [63:0] full_sum = c + product_reg[31:0];
    assign overflow = (full_sum != {32{full_sum[31]}});

    // Booth encoding and partial product generation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [1:0] booth_bits = (i == 0) ? {b_reg[1], b_reg[0], 1'b0} : 
                                    {b_reg[2*i+1], b_reg[2*i], b_reg[2*i-1]};
            wire neg = booth_bits[2] & ~booth_bits[1] & ~booth_bits[0];
            wire pos = ~booth_bits[2] & booth_bits[1] & booth_bits[0];
            wire shift = (booth_bits == 3'b100) | (booth_bits == 3'b011);
            
            assign partial_products[i] = (neg ? -a_reg : pos ? a_reg : 0) << (2*i);
        end
    endgenerate

    // Stage 1: Partial product summation (combinational)
    assign sum_stage1 = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] +
                       partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7] +
                       partial_products[8] + partial_products[9] + partial_products[10] + partial_products[11] +
                       partial_products[12] + partial_products[13] + partial_products[14] + partial_products[15];

    // Stage 2: Final accumulation (sequential)
    always @(posedge clk_gated or posedge rst) begin
        if (rst) begin
            a_reg <= 32'sd0;
            b_reg <= 32'sd0;
            product_reg <= 64'sd0;
            c <= 32'sd0;
            valid_reg <= 1'b0;
        end else if (valid) begin
            // Pipeline stage 1
            a_reg <= a;
            b_reg <= b;
            valid_reg <= 1'b1;
            
            // Pipeline stage 2
            product_reg <= sum_stage1;
            c <= c + product_reg[31:0];
        end else begin
            valid_reg <= 1'b0;
        end
    end

endmodule