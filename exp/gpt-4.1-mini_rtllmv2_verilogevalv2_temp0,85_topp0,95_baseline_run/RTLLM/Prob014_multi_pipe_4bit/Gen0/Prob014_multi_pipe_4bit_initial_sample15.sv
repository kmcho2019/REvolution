module multi_pipe_4bit #(
    parameter size = 4
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [size-1:0]        mul_a,
    input  wire [size-1:0]        mul_b,
    output reg  [(2*size)-1:0]    mul_out
);

    // Extended multiplicand and multiplier by size zeros on MSB side
    wire [(2*size)-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [(2*size)-1:0] ext_b = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            // If bit i of multiplier is 1, partial product is multiplicand shifted left by i,
            // else zero
            assign partial_products[i] = ext_b[i] ? (ext_a << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Registers for pipeline stage 1 to store partial products
    reg [(2*size)-1:0] partial_products_reg [0:size-1];

    // Sum registers for pipeline stage 2 to accumulate sum of partial products
    reg [(2*size)-1:0] sum_reg;

    integer j;

    // Pipeline stage 1: register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                partial_products_reg[j] <= {(2*size){1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                partial_products_reg[j] <= partial_products[j];
            end
        end
    end

    // Pipeline stage 2: sum the partial products stored in registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= {(2*size){1'b0}};
        end else begin
            // Sum all partial products from the pipeline stage 1 registers
            sum_reg <= {(2*size){1'b0}};
            for (j = 0; j < size; j = j + 1) begin
                sum_reg <= sum_reg + partial_products_reg[j];
            end
        end
    end

    // Output register to store the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {(2*size){1'b0}};
        end else begin
            mul_out <= sum_reg;
        end
    end

endmodule