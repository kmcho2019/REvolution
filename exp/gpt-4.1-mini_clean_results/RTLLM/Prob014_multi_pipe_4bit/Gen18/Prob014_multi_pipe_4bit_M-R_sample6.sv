module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding MSBs with zeros for shift operations
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products: if mul_b[i] == 1, shift ext_mul_a by i, else zero
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Combinational sums for first pipeline stage
    wire [2*size-1:0] sum_low  = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_high = partial_products[2] + partial_products[3];

    // Pipeline registers stage 1: register sum_low and sum_high
    reg [2*size-1:0] stage1_sum_low;
    reg [2*size-1:0] stage1_sum_high;

    // Combinational sum for second pipeline stage (sum of stage1 registers)
    wire [2*size-1:0] sum_stage2 = stage1_sum_low + stage1_sum_high;

    // Pipeline register stage 2: register sum_stage2
    reg [2*size-1:0] stage2_sum;

    // Pipeline stage 1 registers update (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
        end else begin
            stage1_sum_low  <= sum_low;
            stage1_sum_high <= sum_high;
        end
    end

    // Pipeline stage 2 register update (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
        end else begin
            stage2_sum <= sum_stage2;
        end
    end

    // Output register update (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule