module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand and multiplier by adding size zero bits at MSB
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b }; // Actually ext_mul_b is unused for multiplication logic, but done as per spec.

    // Generate partial products for each bit of mul_b
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers: two levels
    reg [2*size-1:0] reg_stage1 [1:0]; // 2 registers for stage 1 sums
    reg [2*size-1:0] reg_stage2;       // final register for sum of stage1 registers

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset registers to zero
            for (j = 0; j < 2; j = j + 1)
                reg_stage1[j] <= {2*size{1'b0}};
            reg_stage2 <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end
        else begin
            // First pipeline stage: add partial_products[0] + partial_products[1]
            reg_stage1[0] <= partial_products[0] + partial_products[1];
            // add partial_products[2] + partial_products[3]
            reg_stage1[1] <= partial_products[2] + partial_products[3];

            // Second pipeline stage: add reg_stage1 sums
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];

            // Output assignment
            mul_out <= reg_stage2;
        end
    end

endmodule