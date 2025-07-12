module multi_pipe_4bit #(parameter size=4)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding MSB with size zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products for lower half bits of mul_b (bits 0 and 1)
    wire [2*size-1:0] pp_low_0 = mul_b[0] ? (ext_mul_a << 0) : {2*size{1'b0}};
    wire [2*size-1:0] pp_low_1 = mul_b[1] ? (ext_mul_a << 1) : {2*size{1'b0}};

    // Partial products for upper half bits of mul_b (bits 2 and 3)
    wire [2*size-1:0] pp_high_2 = mul_b[2] ? (ext_mul_a << 2) : {2*size{1'b0}};
    wire [2*size-1:0] pp_high_3 = mul_b[3] ? (ext_mul_a << 3) : {2*size{1'b0}};

    // Stage 1 register: sum of partial products of bits 0 and 1
    reg [2*size-1:0] stage1_sum;

    // Stage 2 register: final product output

    // Stage 1: sum lower partial products and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= {2*size{1'b0}};
        else
            stage1_sum <= pp_low_0 + pp_low_1;
    end

    // Combinational sum of upper partial products
    wire [2*size-1:0] upper_sum = pp_high_2 + pp_high_3;

    // Stage 2: sum upper partial products with stage1_sum and register output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= stage1_sum + upper_sum;
    end

endmodule