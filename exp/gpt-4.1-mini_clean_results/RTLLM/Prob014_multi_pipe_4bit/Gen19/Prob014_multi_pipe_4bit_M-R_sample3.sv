module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zero bits at MSB
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for stage 1 partial products
    reg [2*size-1:0] stage1_regs [size-1:0];

    // Pipeline register for stage 2 sum
    reg [2*size-1:0] stage2_reg;

    integer j;

    // Sequential logic: pipeline update and final product output
    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset all pipeline registers and output to zero
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= {2*size{1'b0}};
            end
            stage2_reg <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            // First pipeline stage: latch partial products
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= partial_products[j];
            end

            // Second pipeline stage: sum all stage1_regs
            stage2_reg <= stage1_regs[0] + stage1_regs[1] + stage1_regs[2] + stage1_regs[3];

            // Output stage: register stage2_reg to mul_out
            mul_out <= stage2_reg;
        end
    end

endmodule