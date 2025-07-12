module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] acc_reg;
    wire signed [31:0] product;
    wire signed [31:0] sum;
    wire clk_gated;
    
    // Clock gating logic (disable when inputs are zero)
    assign clk_gated = clk & ((|a) | (|b) | rst);
    
    // Booth encoded partial products (stage 1)
    wire [32:0] partial_products [15:0];
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [1:0] sel = {b_reg[2*i+1], b_reg[2*i]};
            wire [31:0] pp;
            assign pp = (sel == 2'b01) ? a_reg :
                       (sel == 2'b10) ? -a_reg : 32'd0;
            assign partial_products[i] = {pp[31], pp} << (2*i);
        end
    endgenerate

    // Carry-save adder tree (stage 2)
    wire [32:0] csa_sum [7:0];
    wire [32:0] csa_carry [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : csa_first
            assign {csa_carry[i], csa_sum[i]} = 
                partial_products[2*i] + partial_products[2*i+1];
        end
        
        wire [32:0] stage2_sum [3:0];
        wire [32:0] stage2_carry [3:0];
        for (i = 0; i < 4; i = i + 1) begin : csa_second
            assign {stage2_carry[i], stage2_sum[i]} = 
                csa_sum[2*i] + csa_sum[2*i+1] + csa_carry[2*i] + csa_carry[2*i+1];
        end
        
        wire [32:0] final_sum, final_carry;
        assign {final_carry, final_sum} = 
            stage2_sum[0] + stage2_sum[1] + stage2_sum[2] + stage2_sum[3] +
            stage2_carry[0] + stage2_carry[1] + stage2_carry[2] + stage2_carry[3];
    endgenerate

    // Final product and accumulation
    assign product = final_sum[31:0] + final_carry[31:0];
    assign sum = acc_reg + product;

    // Output assignment
    assign c = acc_reg;

    // Pipelined registers with clock gating and operand isolation
    always @(posedge clk_gated) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            acc_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            acc_reg <= sum;
        end
    end

endmodule