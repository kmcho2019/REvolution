module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by zero-padding MSBs
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline Stage 1 registers: sum pairs of partial products and register results
    reg [2*size-1:0] sum_pair_0_1;  // sum of pp[0] + pp[1]
    reg [2*size-1:0] sum_pair_2_3;  // sum of pp[2] + pp[3]

    wire [2*size-1:0] sum_0_1 = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_2_3 = partial_products[2] + partial_products[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_pair_0_1 <= {2*size{1'b0}};
            sum_pair_2_3 <= {2*size{1'b0}};
        end else begin
            sum_pair_0_1 <= sum_0_1;
            sum_pair_2_3 <= sum_2_3;
        end
    end

    // Pipeline Stage 2: add two registered sums and register the final product
    reg [2*size-1:0] product_reg;
    wire [2*size-1:0] final_sum = sum_pair_0_1 + sum_pair_2_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= {2*size{1'b0}};
            mul_out     <= {2*size{1'b0}};
        end else begin
            product_reg <= final_sum;
            mul_out     <= product_reg;
        end
    end

endmodule