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
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= 0;
            end
        end else begin
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= partial_products[idx];
            end
        end
    end

    // Combinational sum of stage1 partial products
    wire [2*size-1:0] sum_stage1_pp;
    assign sum_stage1_pp = stage1_pp[0]
                         + stage1_pp[1]
                         + stage1_pp[2]
                         + stage1_pp[3];  // size=4 fixed

    // Stage 2 register: final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage1_pp;
        end
    end

endmodule