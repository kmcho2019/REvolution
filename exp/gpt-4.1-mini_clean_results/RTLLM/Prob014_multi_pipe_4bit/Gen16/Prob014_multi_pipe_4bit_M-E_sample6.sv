module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                   clk,
    input                   rst_n,       // Active low reset
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally for each bit of mul_b
    wire [product_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for(i=0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline registers: latch all partial products in parallel
    reg [product_width-1:0] stage1_pp [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j=j+1) begin
                stage1_pp[j] <= {product_width{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j=j+1) begin
                stage1_pp[j] <= partial_products[j];
            end
        end
    end

    // Stage 2: pipeline registers for accumulating partial products sequentially
    // A shift-register style pipeline that on each clock adds the next partial product to accumulated sum
    // We use a counter to track which partial product to add

    reg [1:0] add_index; // counts 0 to size-1 (0 to 3)
    reg [product_width-1:0] acc_sum; // accumulator for partial sums

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            add_index <= 0;
            acc_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            if (add_index == 0) begin
                // First cycle of stage 2: initialize accumulator with first partial product from stage1
                acc_sum <= stage1_pp[0];
                add_index <= add_index + 1;
                mul_out <= {product_width{1'b0}}; // output invalid yet
            end else if (add_index < size) begin
                // Add next partial product into accumulator
                acc_sum <= acc_sum + stage1_pp[add_index];
                add_index <= add_index + 1;
                mul_out <= {product_width{1'b0}}; // output invalid until final addition
            end else begin
                // All partial products added: output final accumulated sum
                mul_out <= acc_sum;
                add_index <= 0;  // restart pipeline for next multiplication inputs
                acc_sum <= {product_width{1'b0}};
            end
        end
    end

endmodule