module multi_pipe_4bit #(parameter size = 4) (
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products_comb [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_comb
            assign partial_products_comb[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1: Register each partial product separately
    reg [2*size-1:0] partial_products_reg [size-1:0];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                partial_products_reg[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                partial_products_reg[j] <= partial_products_comb[j];
        end
    end

    // Stage 2: Sum registered partial products combinationally
    wire [2*size-1:0] sum_stage2;
    assign sum_stage2 = partial_products_reg[0]
                      + partial_products_reg[1]
                      + partial_products_reg[2]
                      + partial_products_reg[3];

    // Register the final product output (stage 2 register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_stage2;
    end

endmodule