module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB to make 2*size bits
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Generate partial products combinationally: for each bit of mul_b,
    // partial product is mul_a shifted left by bit index if bit is set, else 0.
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register each partial product individually
    reg [2*size-1:0] partial_products_reg [size-1:0];

    integer idx;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                partial_products_reg[idx] <= {2*size{1'b0}};
            end
        end else begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                partial_products_reg[idx] <= partial_products[idx];
            end
        end
    end

    // Stage 2 combinational sum of registered partial products
    wire [2*size-1:0] sum_stage2;
    assign sum_stage2 = partial_products_reg[0]
                      + partial_products_reg[1]
                      + partial_products_reg[2]
                      + partial_products_reg[3];

    // Stage 2 register: register the sum and output
    reg [2*size-1:0] sum_stage2_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            sum_stage2_reg <= {2*size{1'b0}};
            mul_out        <= {2*size{1'b0}};
        end else begin
            sum_stage2_reg <= sum_stage2;
            mul_out        <= sum_stage2_reg;
        end
    end

endmodule