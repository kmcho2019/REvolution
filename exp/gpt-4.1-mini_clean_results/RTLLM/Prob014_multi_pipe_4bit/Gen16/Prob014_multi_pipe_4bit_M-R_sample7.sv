module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products (combinationally generated)
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products
    reg [2*size-1:0] stage1_regs [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= 0;
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= partial_products[j];
        end
    end

    // Stage 2: adder tree to sum partial products in two pipeline registers
    // First level of additions (sum pairs of stage1_regs)
    wire [2*size-1:0] sum_level1 [0:(size/2)-1];
    genvar k;
    generate
        for (k = 0; k < size/2; k = k + 1) begin : gen_sum_level1
            assign sum_level1[k] = stage1_regs[2*k] + stage1_regs[2*k+1];
        end
    endgenerate

    // If size is odd (for generality), handle last partial product alone
    // But since size=4 fixed, this is skipped.

    // Stage 2 registers: store first level sums
    reg [2*size-1:0] stage2_regs [0:(size/2)-1];
    integer m;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (m = 0; m < size/2; m = m + 1)
                stage2_regs[m] <= 0;
        end else begin
            for (m = 0; m < size/2; m = m + 1)
                stage2_regs[m] <= sum_level1[m];
        end
    end

    // Final sum of stage2_regs (two operands since size=4)
    wire [2*size-1:0] final_sum = stage2_regs[0] + stage2_regs[1];

    // Final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= final_sum;
    end

endmodule