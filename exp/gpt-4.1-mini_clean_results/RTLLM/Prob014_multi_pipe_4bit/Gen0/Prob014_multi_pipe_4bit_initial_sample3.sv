module multi_pipe_4bit #
(
    parameter size = 4
)
(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extended inputs by appending 'size' zeros on MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two levels of registers to store intermediate sums

    // First level register: sum of partial products 0 and 1
    reg [2*size-1:0] reg_level1_0;
    reg [2*size-1:0] reg_level1_1;

    // Second level register: sum of partial products 2 and 3
    reg [2*size-1:0] reg_level2_0;
    reg [2*size-1:0] reg_level2_1;

    // At clock, accumulate first two and last two partial products in separate registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_level1_0 <= {2*size{1'b0}};
            reg_level1_1 <= {2*size{1'b0}};
            reg_level2_0 <= {2*size{1'b0}};
            reg_level2_1 <= {2*size{1'b0}};
        end else begin
            reg_level1_0 <= partial_products[0];
            reg_level1_1 <= partial_products[1];
            reg_level2_0 <= partial_products[2];
            reg_level2_1 <= partial_products[3];
        end
    end

    // Second always block sums the first level and second level sums and outputs the product
    // Since the problem states two levels of registers for intermediate values and control multiplication process,
    // we add them in two stages. First stage stored above, next stage sums them and stores final product.
    reg [2*size-1:0] sum_level1;
    reg [2*size-1:0] sum_level2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level1 <= {2*size{1'b0}};
            sum_level2 <= {2*size{1'b0}};
            mul_out   <= {2*size{1'b0}};
        end else begin
            sum_level1 <= reg_level1_0 + reg_level1_1;
            sum_level2 <= reg_level2_0 + reg_level2_1;
            mul_out   <= sum_level1 + sum_level2;
        end
    end

endmodule