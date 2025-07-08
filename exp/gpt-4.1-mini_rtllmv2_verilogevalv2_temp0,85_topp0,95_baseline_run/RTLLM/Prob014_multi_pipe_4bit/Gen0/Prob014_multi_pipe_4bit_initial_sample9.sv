module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a }; // 8 bits: upper 4 zeros + mul_a

    // Partial products generation
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers to store intermediate sums (first level)
    reg [2*size-1:0] sum_level1_0, sum_level1_1;

    // Pipeline registers to store intermediate sums (second level)
    reg [2*size-1:0] sum_level2;

    // First level addition pipeline (add partial_products[0] + partial_products[1], and partial_products[2] + partial_products[3])
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level1_0 <= 0;
            sum_level1_1 <= 0;
        end else begin
            sum_level1_0 <= partial_products[0] + partial_products[1];
            sum_level1_1 <= partial_products[2] + partial_products[3];
        end
    end

    // Second level addition pipeline (add sum_level1_0 + sum_level1_1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2 <= 0;
        end else begin
            sum_level2 <= sum_level1_0 + sum_level1_1;
        end
    end

    // Final product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_level2;
        end
    end

endmodule