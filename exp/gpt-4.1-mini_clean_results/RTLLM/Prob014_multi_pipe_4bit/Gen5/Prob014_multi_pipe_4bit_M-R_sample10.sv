module multi_pipe_4bit #(parameter size = 4)(
    input                     clk,
    input                     rst_n,
    input       [size-1:0]    mul_a,
    input       [size-1:0]    mul_b,
    output reg  [2*size-1:0]  mul_out
);

    // Stage 0: Register inputs and extend mul_a
    reg [size-1:0] mul_a_reg, mul_b_reg;
    reg [2*size-1:0] ext_mul_a_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg     <= 0;
            mul_b_reg     <= 0;
            ext_mul_a_reg <= 0;
        end else begin
            mul_a_reg     <= mul_a;
            mul_b_reg     <= mul_b;
            ext_mul_a_reg <= {{size{1'b0}}, mul_a};  // Extend multiplicand by size zero bits at MSB
        end
    end

    // Stage 1: Combinational partial product generation based on registered inputs
    // Generate partial products for each bit in mul_b_reg
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (ext_mul_a_reg << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1: Register partial products
    reg [2*size-1:0] partial_products_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                partial_products_reg[j] <= 0;
        end else begin
            for (j = 0; j < size; j = j + 1)
                partial_products_reg[j] <= partial_products[j];
        end
    end

    // Stage 2: Sum partial products and register output
    reg [2*size-1:0] sum_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 0;
            mul_out <= 0;
        end else begin
            // Sum all partial products registered in stage 1
            sum_stage2 <= 0;
            for (j = 0; j < size; j = j + 1)
                sum_stage2 <= sum_stage2 + partial_products_reg[j];

            mul_out <= sum_stage2;
        end
    end

endmodule