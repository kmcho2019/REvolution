module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding size zeros at MSB (left)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1 registers: register extended multiplicand and multiplier inputs
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Stage 2 registers: partial products for each bit of multiplier
    reg [2*size-1:0] stage2_partials [0:size-1];

    integer i;
    
    // Generate partial products combinationally from Stage 1 registered inputs
    wire [2*size-1:0] partial_products [0:size-1];
    generate
        genvar idx;
        for (idx = 0; idx < size; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = (stage1_mul_b[idx]) ? (stage1_mul_a << idx) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 3: sum all partial products and register final product output
    wire [2*size-1:0] sum_partials;

    // Sum partial products combinationally
    assign sum_partials = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];

    // Sequential logic: pipeline registers and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
            for (i = 0; i < size; i = i + 1) begin
                stage2_partials[i] <= {2*size{1'b0}};
            end
            mul_out <= {2*size{1'b0}};
        end else begin
            // Stage 1: register inputs
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;

            // Stage 2: register partial products generated from Stage1 registers
            for (i = 0; i < size; i = i + 1) begin
                stage2_partials[i] <= partial_products[i];
            end

            // Stage 3: register sum of partial products (from Stage 2 registered partials)
            // Note: partial_products are combinational from stage1 registers, 
            // but we want to sum stage2 registers (the registered partials)
            // So sum after they are registered:
            mul_out <= stage2_partials[0] + stage2_partials[1] + stage2_partials[2] + stage2_partials[3];
        end
    end

endmodule