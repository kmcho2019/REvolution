module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output              mul_en_out,
    output reg  [15:0]  mul_out
);

    // Pipeline depth = 9 for mul_en_out shift register: mul_en_in and 8 pipeline stages
    reg [8:0] mul_en_out_reg;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: 8 partial products (mul_b_reg bits)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate

    // Pipeline registers for partial sums (8 stages)
    reg [15:0] sum_stage [7:0];

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_en_out_reg <= 9'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            for (j=0; j<8; j=j+1) begin
                sum_stage[j] <= 16'b0;
            end
            mul_out <= 16'b0;
        end else begin
            // Shift in input enable signal to mul_en_out_reg
            mul_en_out_reg <= {mul_en_out_reg[7:0], mul_en_in};

            // Register inputs only if mul_en_in is asserted
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Pipeline partial sums accumulation:
            // Stage 0 sum is partial_products[0]
            sum_stage[0] <= partial_products[0];
            // Stage 1 sum is sum_stage[0] + partial_products[1]
            for (j = 1; j < 8; j = j + 1) begin
                sum_stage[j] <= sum_stage[j-1] + partial_products[j];
            end

            // Final output is last stage sum
            mul_out <= mul_en_out_reg[8] ? sum_stage[7] : 16'b0;
        end
    end

    // Output enable is the most significant bit of mul_en_out_reg
    assign mul_en_out = mul_en_out_reg[8];

endmodule