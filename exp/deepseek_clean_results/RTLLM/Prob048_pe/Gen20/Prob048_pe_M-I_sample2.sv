module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals
    reg signed [31:0] acc_reg;
    wire signed [31:0] next_acc;
    wire clk_gated;
    wire mult_valid;
    
    // Pipeline registers for multiplier
    reg signed [31:0] a_reg, b_reg;
    wire signed [63:0] partial_products [15:0];
    reg signed [63:0] sum_stage1;
    wire signed [63:0] product;
    
    // Clock gating logic
    assign mult_valid = (a != 0) && (b != 0);
    assign clk_gated = clk & (~rst & mult_valid);

    // Booth encoded multiplier (2-stage pipeline)
    // Stage 1: Partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Generate partial products using Booth encoding
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth_partials
            wire [2:0] booth_sel = {b_reg[2*i+1], b_reg[2*i], (i == 0) ? 1'b0 : b_reg[2*i-1]};
            wire signed [32:0] pp;
            
            assign pp = (booth_sel == 3'b001 || booth_sel == 3'b010) ? {a_reg[31], a_reg} :
                       (booth_sel == 3'b011) ? {a_reg, 1'b0} :
                       (booth_sel == 3'b100) ? ~{a_reg, 1'b0} + 1'b1 :
                       (booth_sel == 3'b101 || booth_sel == 3'b110) ? ~{a_reg[31], a_reg} + 1'b1 :
                       33'b0;
            
            assign partial_products[i] = {{(32-2*i){pp[32]}}, pp[32:0], {2*i{1'b0}}};
        end
    endgenerate
    
    // Stage 2: Partial product summation (tree structure)
    always @(posedge clk) begin
        if (rst) begin
            sum_stage1 <= 64'd0;
        end else begin
            // First level of adder tree
            sum_stage1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] +
                          partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7] +
                          partial_products[8] + partial_products[9] + partial_products[10] + partial_products[11] +
                          partial_products[12] + partial_products[13] + partial_products[14] + partial_products[15];
        end
    end
    
    assign product = sum_stage1;
    
    // Next accumulation value (combinational)
    assign next_acc = acc_reg + product[31:0];

    // Output assignment
    assign c = acc_reg;

    // Sequential accumulation with synchronous reset and clock gating
    always @(posedge clk_gated or posedge rst) begin
        if (rst) begin
            acc_reg <= 32'd0;
        end else begin
            acc_reg <= next_acc;
        end
    end

endmodule