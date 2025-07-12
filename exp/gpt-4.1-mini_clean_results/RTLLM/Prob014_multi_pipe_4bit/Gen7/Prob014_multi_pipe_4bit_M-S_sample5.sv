module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);
    localparam product_width = 2 * size;

    // Zero-extend multiplicand by size bits at MSB side
    wire [product_width-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products for each bit of mul_b
    wire [product_width-1:0] partial [0:size-1];
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // First pipeline stage: sum partial products into an intermediate register
    reg [product_width-1:0] sum_stage1;
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_stage1 <= {product_width{1'b0}};
        else begin
            // Sum all partial products combinationally, then register result
            sum_stage1 <= {product_width{1'b0}};
            for (idx = 0; idx < size; idx = idx + 1)
                sum_stage1 <= sum_stage1 + partial[idx];
        end
    end

    // Second pipeline stage: register the final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_stage1;
    end

endmodule