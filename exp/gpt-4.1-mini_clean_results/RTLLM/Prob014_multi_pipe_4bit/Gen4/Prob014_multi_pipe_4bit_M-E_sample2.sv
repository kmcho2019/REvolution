module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input  [size-1:0]        mul_a,
    input  [size-1:0]        mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend multiplicand and multiplier by size zeros at MSB
    // As per problem statement, we add 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a_init = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b_init = { {size{1'b0}}, mul_b };

    // ---------------------------
    // Stage 1 Registers: store intermediate values for multiplication process
    reg [2*size-1:0] multiplicand_reg;  // Shifted multiplicand for each bit position
    reg [2*size-1:0] multiplier_reg;    // Shifted multiplier to extract bits serially
    reg [2*size-1:0] partial_sum_reg;   // Accumulated sum of partial products

    // Counter to track bits processed (optional for clarity)
    reg [$clog2(size+1)-1:0] bit_count;

    // ---------------------------
    // Stage 2 Register: holds final product output after accumulation
    reg [2*size-1:0] product_reg;

    // ---------------------------
    // On reset or clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to zero
            multiplicand_reg <= {2*size{1'b0}};
            multiplier_reg   <= {2*size{1'b0}};
            partial_sum_reg  <= {2*size{1'b0}};
            product_reg      <= {2*size{1'b0}};
            bit_count        <= {($clog2(size+1)){1'b0}};
            mul_out          <= {2*size{1'b0}};
        end else begin
            if (bit_count == 0) begin
                // Load initial extended multiplicand and multiplier at start of multiplication
                multiplicand_reg <= ext_mul_a_init;
                multiplier_reg   <= ext_mul_b_init;
                partial_sum_reg  <= {2*size{1'b0}};
                bit_count        <= 1;
            end else if (bit_count < size+1) begin
                // Extract LSB of multiplier_reg
                if (multiplier_reg[0] == 1'b1) begin
                    // Add multiplicand_reg to partial sum if current multiplier bit is 1
                    partial_sum_reg <= partial_sum_reg + multiplicand_reg;
                end else begin
                    // No addition if multiplier bit is 0
                    partial_sum_reg <= partial_sum_reg;
                end

                // Shift multiplicand left by 1 for next bit
                multiplicand_reg <= multiplicand_reg << 1;

                // Shift multiplier right by 1 to process next bit
                multiplier_reg <= multiplier_reg >> 1;

                bit_count <= bit_count + 1;
            end else begin
                // After size bits processed, move accumulated sum to stage 2 register
                product_reg <= partial_sum_reg;

                // Keep values stable until next operation or reset
                multiplicand_reg <= multiplicand_reg;
                multiplier_reg   <= multiplier_reg;
                partial_sum_reg  <= partial_sum_reg;
                bit_count <= bit_count; 
            end

            // Update output with stage 2 register value (final product)
            mul_out <= product_reg;
        end
    end

endmodule