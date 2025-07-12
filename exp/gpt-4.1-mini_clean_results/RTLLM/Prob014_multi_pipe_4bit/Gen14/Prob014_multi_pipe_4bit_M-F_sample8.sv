module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store each partial product
    reg [2*size-1:0] stage1_pp [0:size-1];

    // Register stage1 partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            integer idx;
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= {2*size{1'b0}};
            end
        end else begin
            integer idx;
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= partial_products[idx];
            end
        end
    end

    // Balanced combinational summation of stage1 partial products
    // Implement summation using a tree of adders in generate blocks
    // We create a function to sum an array of vectors
    function automatic [2*size-1:0] sum_array;
        input [2*size-1:0] arr [0:size-1];
        integer j;
        reg [2*size-1:0] temp_sum;
        begin
            temp_sum = {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1)
                temp_sum = temp_sum + arr[j];
            sum_array = temp_sum;
        end
    endfunction

    wire [2*size-1:0] sum_stage1_pp = sum_array(stage1_pp);

    // Stage 2 register: final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_stage1_pp;
        end
    end

endmodule