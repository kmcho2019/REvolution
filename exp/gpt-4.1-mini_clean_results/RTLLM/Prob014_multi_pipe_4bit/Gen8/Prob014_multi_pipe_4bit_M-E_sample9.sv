module multi_pipe_4bit #(
    parameter size = 4,
    localparam product_width = 2 * size
)(
    input                     clk,
    input                     rst_n,       // active low reset
    input  [size-1:0]         mul_a,
    input  [size-1:0]         mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand to product width
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Partial products as wires
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register each partial product individually
    reg [product_width-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(j=0; j<size; j=j+1)
                pp_reg[j] <= {product_width{1'b0}};
        end else begin
            for(j=0; j<size; j=j+1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2 registers: sum of partial products 0 & 1, and partial products 2 & 3
    reg [product_width-1:0] sum_low;
    reg [product_width-1:0] sum_high;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum_low  <= {product_width{1'b0}};
            sum_high <= {product_width{1'b0}};
        end else begin
            sum_low  <= pp_reg[0] + pp_reg[1];
            sum_high <= pp_reg[2] + pp_reg[3];
        end
    end

    // Stage 3 register: final sum to output
    reg [product_width-1:0] final_sum;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            final_sum <= {product_width{1'b0}};
            mul_out   <= {product_width{1'b0}};
        end else begin
            final_sum <= sum_low + sum_high;
            mul_out   <= final_sum;
        end
    end

endmodule