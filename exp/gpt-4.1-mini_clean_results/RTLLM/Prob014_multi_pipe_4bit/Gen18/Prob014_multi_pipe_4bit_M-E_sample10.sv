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

    // Extend multiplicand by size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Stage 1: Generate all partial products combinationally
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Pipeline registers for partial products (stage 1 registers)
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2: Perform additions in pipeline stage 2
    // Sum partial products 0 & 1 and 2 & 3 separately, then sum those two results
    reg [product_width-1:0] sum01_reg, sum23_reg;
    reg [product_width-1:0] product_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum01_reg <= {product_width{1'b0}};
            sum23_reg <= {product_width{1'b0}};
            product_reg <= {product_width{1'b0}};
        end else begin
            sum01_reg <= pp_reg[0] + pp_reg[1];
            sum23_reg <= pp_reg[2] + pp_reg[3];
            product_reg <= sum01_reg + sum23_reg;
        end
    end

    // Output assignment with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= product_reg;
    end

endmodule