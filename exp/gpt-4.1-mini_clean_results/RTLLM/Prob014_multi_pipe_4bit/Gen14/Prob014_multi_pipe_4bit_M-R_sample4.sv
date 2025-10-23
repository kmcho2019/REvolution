module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand with zeros at MSB to 2*size width
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally in a packed vector
    // Each partial product is 2*size bits wide, total size elements
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline register: store all partial products in a packed vector
    reg [2*size-1:0] stage1_pp [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1)
                stage1_pp[j] <= {2*size{1'b0}};
        end else begin
            for (j=0; j<size; j=j+1)
                stage1_pp[j] <= partial_products[j];
        end
    end

    // Stage 2 pipeline: sum all stage1 partial products and register output
    // Sum computed inside sequential always block for clear pipeline behavior
    reg [2*size-1:0] sum_pp;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_pp <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            sum_pp = {2*size{1'b0}};
            for (j=0; j<size; j=j+1)
                sum_pp = sum_pp + stage1_pp[j];
            mul_out <= sum_pp;
        end
    end

endmodule