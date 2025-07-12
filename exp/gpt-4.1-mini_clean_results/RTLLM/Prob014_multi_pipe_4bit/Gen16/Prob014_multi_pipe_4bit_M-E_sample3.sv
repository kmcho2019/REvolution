module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
) (
    input                   clk,
    input                   rst_n,         // async active-low reset
    input       [size-1:0]  mul_a,
    input       [size-1:0]  mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Zero-extended multiplicand (left-padded with zeros)
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Counter to track which bit of mul_b is being processed
    reg [$clog2(size):0] bit_counter;

    // Partial sum accumulator register
    reg [product_width-1:0] partial_sum;

    // Stage 1 register: Stores the current bit of multiplier and shifted multiplicand addition result
    reg [product_width-1:0] stage1_sum;

    // Control signal: process active when bit_counter < size
    wire processing = (bit_counter < size);

    // Extract current multiplier bit for processing
    wire current_bit = mul_b[bit_counter];

    // Shift multiplicand by bit_counter
    wire [product_width-1:0] shifted_mul_a = mul_a_ext << bit_counter;

    // Combinational logic: add shifted multiplicand if current multiplier bit is 1
    wire [product_width-1:0] add_result = current_bit ? (partial_sum + shifted_mul_a) : partial_sum;

    // Pipeline Stage 1: On clk, update partial_sum accumulator and increment bit_counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum <= {product_width{1'b0}};
            bit_counter <= 0;
            stage1_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            if (processing) begin
                stage1_sum <= add_result;  // register sum after add/sub
                partial_sum <= add_result; // update partial sum accumulator
                bit_counter <= bit_counter + 1;
            end else begin
                stage1_sum <= stage1_sum; // hold stage1_sum stable after processing done
            end

            // Stage 2: Once all bits processed, register final product output
            if (bit_counter == size) begin
                mul_out <= stage1_sum;    // output final sum at next clock
                // Reset partial_sum and counter for next multiplication cycle
                partial_sum <= {product_width{1'b0}};
                bit_counter <= 0;
            end
        end
    end

endmodule