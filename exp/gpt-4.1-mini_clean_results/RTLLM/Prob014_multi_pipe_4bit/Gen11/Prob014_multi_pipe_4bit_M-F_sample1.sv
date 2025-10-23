module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,   // active low reset
    input      [size-1:0]   mul_a,   // multiplicand input
    input      [size-1:0]   mul_b,   // multiplier input
    output reg [2*size-1:0] mul_out  // product output
);

    // Extend multiplicand by padding 'size' zeros at MSB (left side)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Pipeline Stage 1: Registers for inputs
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Pipeline Stage 2: Registers for partial products
    reg [2*size-1:0] stage2_partials [0:size-1];

    integer i;

    // Partial product generation combinational block (based on stage1 registers)
    wire [2*size-1:0] partial_products [0:size-1];

    generate
        genvar idx;
        for (idx = 0; idx < size; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = (stage1_mul_b[idx]) ? (stage1_mul_a << idx) : {2*size{1'b0}};
        end
    endgenerate

    // Sum of the registered partial products (stage 2) combinational
    wire [2*size-1:0] sum_stage2_partials;
    assign sum_stage2_partials = 
          stage2_partials[0] 
        + stage2_partials[1] 
        + stage2_partials[2] 
        + stage2_partials[3];

    // Sequential logic: pipeline registers and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear all registers and output
            stage1_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
            for (i = 0; i < size; i = i + 1) begin
                stage2_partials[i] <= {2*size{1'b0}};
            end
            mul_out <= {2*size{1'b0}};
        end else begin
            // Stage 1: register inputs (extended multiplicand and multiplier)
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;

            // Stage 2: register partial products generated from stage1 registered inputs
            for (i = 0; i < size; i = i + 1) begin
                stage2_partials[i] <= partial_products[i];
            end

            // Stage 3: register the sum of stage 2 partial products to output
            mul_out <= sum_stage2_partials;
        end
    end

endmodule