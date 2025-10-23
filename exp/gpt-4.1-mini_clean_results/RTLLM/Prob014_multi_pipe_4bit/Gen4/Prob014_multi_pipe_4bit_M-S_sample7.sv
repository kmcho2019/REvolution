module multi_pipe_4bit #(parameter size = 4) (
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend inputs by size zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Partial products array
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for intermediate sums
    reg [2*size-1:0] stage1_sum; // sum of pp0 and pp1
    reg [2*size-1:0] stage2_sum; // sum of pp2 and pp3
    reg [2*size-1:0] product_reg; // final product register

    // Stage 1: sum partial products pp0 and pp1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= {2*size{1'b0}};
        else
            stage1_sum <= partial_products[0] + partial_products[1];
    end

    // Stage 2: sum partial products pp2 and pp3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage2_sum <= {2*size{1'b0}};
        else
            stage2_sum <= partial_products[2] + partial_products[3];
    end

    // Stage 3: add stage1_sum and stage2_sum to get final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product_reg <= {2*size{1'b0}};
        else
            product_reg <= stage1_sum + stage2_sum;
    end

    // Registered output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= product_reg;
    end

endmodule