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

    // Pipeline registers stage 1: store partial products
    reg [2*size-1:0] stage1_regs [size-1:0];

    // Pipeline register stage 2: store sum of partial products
    reg [2*size-1:0] stage2_reg;

    integer j;

    // Stage 1 pipeline: latch partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= {2*size{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= partial_products[j];
            end
        end
    end

    // Stage 2 pipeline: sum partial products from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= {2*size{1'b0}};
        end else begin
            stage2_reg <= stage1_regs[0] + stage1_regs[1] + stage1_regs[2] + stage1_regs[3];
        end
    end

    // Output register stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_reg;
        end
    end

endmodule