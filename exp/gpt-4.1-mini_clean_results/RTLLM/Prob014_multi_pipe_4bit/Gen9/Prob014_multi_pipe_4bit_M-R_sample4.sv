module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Stage 1: extend multiplicand by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Pipeline registers for Stage 1 (inputs)
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Partial products generated combinationally from Stage 1 registered inputs
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            // For each bit of multiplier, partial product is either shifted multiplicand or zero
            assign partial_products[i] = (stage1_mul_b[i]) ? (stage1_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 2: registers to hold partial sums after first addition step
    reg [2*size-1:0] stage2_sum_lower;  // sum of partial_products[0] and [1]
    reg [2*size-1:0] stage2_sum_upper;  // sum of partial_products[2] and [3]

    // Combinational sums of partial products for Stage 2 registers
    wire [2*size-1:0] sum_lower_wire = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_upper_wire = partial_products[2] + partial_products[3];

    // Stage 3: registers to hold final sum before output
    reg [2*size-1:0] stage3_sum;

    // Combinational sum of stage 2 registered sums
    wire [2*size-1:0] final_sum_wire = stage2_sum_lower + stage2_sum_upper;

    // Sequential logic: pipeline registers with synchronous clock and async active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a    <= {2*size{1'b0}};
            stage1_mul_b    <= {size{1'b0}};
            stage2_sum_lower<= {2*size{1'b0}};
            stage2_sum_upper<= {2*size{1'b0}};
            stage3_sum      <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Stage 1: register inputs (extended multiplicand and multiplier)
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;

            // Stage 2: register sums of partial products computed combinationally
            stage2_sum_lower <= sum_lower_wire;
            stage2_sum_upper <= sum_upper_wire;

            // Stage 3: register final sum computed combinationally from Stage 2 registers
            stage3_sum <= final_sum_wire;

            // Output registered from Stage 3 sum
            mul_out <= stage3_sum;
        end
    end

endmodule