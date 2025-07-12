module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,     // active low reset
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extended multiplicand: prepend 'size' zeros on MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products: each either (ext_mul_a << i) or zero
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline registers: sum partial_products[0] + partial_products[1], and partial_products[2] + partial_products[3]
    reg [2*size-1:0] stage1_sum_low;
    reg [2*size-1:0] stage1_sum_high;

    // Stage 2 pipeline register: final sum of stage1 sums
    reg [2*size-1:0] stage2_sum;

    // Stage 1 combinational sums
    wire [2*size-1:0] sum_low  = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_high = partial_products[2] + partial_products[3];

    // Stage 1 registers latch sums at posedge clk or reset async
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
        end else begin
            stage1_sum_low  <= sum_low;
            stage1_sum_high <= sum_high;
        end
    end

    // Stage 2 register adds stage1 sums to form final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            stage2_sum <= stage1_sum_low + stage1_sum_high;
            mul_out    <= stage2_sum;
        end
    end

endmodule