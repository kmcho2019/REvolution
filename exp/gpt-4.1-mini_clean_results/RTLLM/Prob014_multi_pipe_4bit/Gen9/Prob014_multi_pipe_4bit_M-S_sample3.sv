module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = 2*size; // Extended width = 8 for size=4

    // Stage 1 registers: extended multiplicand and multiplier
    reg [ext_size-1:0] reg_mul_a;
    reg [size-1:0]     reg_mul_b;

    // Stage 2 register: store intermediate sum of partial products
    reg [ext_size-1:0] intermediate_sum;

    integer i;
    wire [ext_size-1:0] partial_products [size-1:0];
    wire [ext_size-1:0] sum_partial_products;

    // Extend multiplicand by zero-padding MSBs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {ext_size{1'b0}};
            reg_mul_b <= {size{1'b0}};
        end else begin
            reg_mul_a <= {{size{1'b0}}, mul_a}; // zero-extend mul_a at MSB
            reg_mul_b <= mul_b;
        end
    end

    // Generate partial products for each bit of multiplier
    generate
        genvar idx;
        for (idx=0; idx<size; idx=idx+1) begin : gen_partial_products
            assign partial_products[idx] = reg_mul_b[idx] ? (reg_mul_a << idx) : {ext_size{1'b0}};
        end
    endgenerate

    // Sum all partial products combinationally
    assign sum_partial_products = partial_products[0] 
                                + partial_products[1] 
                                + partial_products[2] 
                                + partial_products[3];

    // Stage 2: Register intermediate sum of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            intermediate_sum <= {ext_size{1'b0}};
        else
            intermediate_sum <= sum_partial_products;
    end

    // Stage 3: Register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {ext_size{1'b0}};
        else
            mul_out <= intermediate_sum;
    end

endmodule