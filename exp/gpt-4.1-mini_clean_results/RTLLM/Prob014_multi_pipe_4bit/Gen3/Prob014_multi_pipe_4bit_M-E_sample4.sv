module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam width = 2*size;

    // Counter to index mul_b bits (0 to size-1)
    reg [$clog2(size):0] bit_idx; 

    // Stage 1 register: current partial product (width bits)
    reg [width-1:0] partial_product_reg;

    // Stage 2 register: accumulated sum of partial products
    reg [width-1:0] accumulator_reg;

    // Combinational partial product for current bit
    wire [width-1:0] partial_product_comb;

    // Generate partial product for current bit:
    // If mul_b[bit_idx] == 1, partial product = mul_a shifted left by bit_idx
    assign partial_product_comb = mul_b[bit_idx] ? ({{(size){1'b0}}, mul_a} << bit_idx) : {width{1'b0}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_idx <= 0;
            partial_product_reg <= {width{1'b0}};
            accumulator_reg <= {width{1'b0}};
            mul_out <= {width{1'b0}};
        end else begin
            if (bit_idx < size) begin
                // Stage 1: register the partial product of current bit
                partial_product_reg <= partial_product_comb;

                // Stage 2: accumulate partial products
                accumulator_reg <= accumulator_reg + partial_product_reg;

                bit_idx <= bit_idx + 1;

                // Reset output until last cycle
                mul_out <= {width{1'b0}};
            end else begin
                // After all bits processed, output the accumulated sum
                mul_out <= accumulator_reg;

                // Reset for next multiplication
                bit_idx <= 0;
                partial_product_reg <= {width{1'b0}};
                accumulator_reg <= {width{1'b0}};
            end
        end
    end

endmodule