module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
)(
    input                       clk,
    input                       rst_n,       // active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend multiplicand by zero-padding at MSB side
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Partial products array
    wire [product_width-1:0] partial_products [0:size-1];
    
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // First pipeline stage registers for partial products
    reg [product_width-1:0] pp_regs [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_regs[j] <= {product_width{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_regs[j] <= partial_products[j];
        end
    end

    // Second pipeline stage registers for sum of partial products
    reg [product_width-1:0] sum_stage;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage <= {product_width{1'b0}};
        end else begin
            // Sum all pp_regs values
            sum_stage <= pp_regs[0] + pp_regs[1] + pp_regs[2] + pp_regs[3];
        end
    end

    // Output register (third pipeline stage) to hold final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= sum_stage;
        end
    end

endmodule