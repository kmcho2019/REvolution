module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand and multiplier by size zeros at MSB side
    // Extension: {size{1'b0}} concatenated on MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_mul_b = {{size{1'b0}}, mul_b};

    // ---------------------------
    // Level 1 pipeline registers: partial products for each bit of multiplier
    // ---------------------------
    reg [2*size-1:0] partial_products_reg [0:size-1];

    // ---------------------------
    // Level 2 pipeline register: sum of partial products
    // ---------------------------
    reg [2*size-1:0] sum_reg;

    // ---------------------------
    // Combinational partial products based on registered multiplier bits and extended multiplicand
    // ---------------------------
    wire [2*size-1:0] partial_products_comb [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            // If mul_b[i] = 1, partial product = ext_mul_a shifted left by i; else 0
            assign partial_products_comb[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear pipeline registers and output on reset
            for (idx=0; idx<size; idx=idx+1) begin
                partial_products_reg[idx] <= {2*size{1'b0}};
            end
            sum_reg <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            // Level 1 pipeline registers: capture partial products
            for (idx=0; idx<size; idx=idx+1) begin
                partial_products_reg[idx] <= partial_products_comb[idx];
            end

            // Level 2 pipeline register: sum of partial products from Level 1 registers
            sum_reg <= partial_products_reg[0] + partial_products_reg[1] + partial_products_reg[2] + partial_products_reg[3];

            // Output update from sum register
            mul_out <= sum_reg;
        end
    end

endmodule