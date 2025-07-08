module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend inputs by size bits at MSB (zeros)
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b}; // although ext_b is not used directly

    // Partial products array
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i]) ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Registers for pipeline stages
    reg [2*size-1:0] stage1_reg; // sum of first half partial products
    reg [2*size-1:0] stage2_reg; // sum of second half partial products

    // Temporary sums for the first and second half partial products
    wire [2*size-1:0] first_half_sum;
    wire [2*size-1:0] second_half_sum;

    // Sum first half partial products combinationally
    assign first_half_sum = partial_products[0] + partial_products[1];

    if (size > 2) begin
        assign first_half_sum = partial_products[0] + partial_products[1];
    end

    // Sum second half partial products combinationally
    generate
        if (size > 2) begin
            assign second_half_sum = partial_products[2] + partial_products[3];
        end else begin
            assign second_half_sum = {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= {2*size{1'b0}};
            stage2_reg <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            stage1_reg <= first_half_sum;
            stage2_reg <= second_half_sum;
            mul_out    <= stage1_reg + stage2_reg;
        end
    end

endmodule