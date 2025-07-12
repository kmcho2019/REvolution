module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
) (
    input                       clk,
    input                       rst_n,
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Stage 0: Register input operands to stabilize inputs during pipeline
    reg [size-1:0] mul_a_reg, mul_b_reg;
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_a_reg <= {size{1'b0}};
            mul_b_reg <= {size{1'b0}};
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Extend multiplicand by 'size' zero bits on MSB side (synchronous with pipeline)
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a_reg};

    // Stage 1: Generate partial products combinationally based on mul_b_reg bits
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline registers for partial products
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2: Sum pairs of partial products
    reg [product_width-1:0] sum01_reg, sum23_reg;
    always @(posedge clk) begin
        if (!rst_n) begin
            sum01_reg <= {product_width{1'b0}};
            sum23_reg <= {product_width{1'b0}};
        end else begin
            sum01_reg <= pp_reg[0] + pp_reg[1];
            sum23_reg <= pp_reg[2] + pp_reg[3];
        end
    end

    // Stage 3: Sum stage 2 outputs and register final product
    reg [product_width-1:0] product_reg;
    always @(posedge clk) begin
        if (!rst_n) begin
            product_reg <= {product_width{1'b0}};
        end else begin
            product_reg <= sum01_reg + sum23_reg;
        end
    end

    // Output assignment
    always @(posedge clk) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= product_reg;
    end

endmodule