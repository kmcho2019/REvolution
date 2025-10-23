module multi_pipe_4bit #(
    parameter size = 4
)(
    input                  clk,
    input                  rst_n,
    input  [size-1:0]      mul_a,
    input  [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by size zeros at MSB as per spec
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Pipeline registers - Level 1
    reg [2*size-1:0] reg_mul_a;       // multiplicand extended
    reg [2*size-1:0] reg_partial_sum; // partial sum accumulator
    reg [size:0]     reg_bit_idx;     // bit index (0 to size)
    reg [2*size-1:0] reg_mul_b;       // multiplier extended

    // Pipeline registers - Level 2
    reg [2*size-1:0] reg_next_partial_sum;
    reg [size:0]     reg_next_bit_idx;

    // Control signals
    wire processing_done = (reg_next_bit_idx == size);

    // At each pipeline stage, examine multiplier bit and update partial sum
    wire current_bit = reg_mul_b[reg_bit_idx];

    wire [2*size-1:0] shifted_multiplicand = ext_mul_a << reg_bit_idx;

    // Compute new partial sum based on current bit
    wire [2*size-1:0] updated_partial_sum = current_bit ? (reg_partial_sum + shifted_multiplicand) : reg_partial_sum;

    // Pipeline Stage 1: Capture inputs and propagate partial sum, bit index, multiplier
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a       <= {2*size{1'b0}};
            reg_mul_b       <= {2*size{1'b0}};
            reg_partial_sum <= {2*size{1'b0}};
            reg_bit_idx     <= 0;
        end else if (reg_bit_idx < size) begin
            reg_mul_a       <= ext_mul_a;
            reg_mul_b       <= ext_mul_b;
            reg_partial_sum <= reg_next_partial_sum;
            reg_bit_idx     <= reg_next_bit_idx;
        end else begin
            // Hold values after completion
            reg_mul_a       <= reg_mul_a;
            reg_mul_b       <= reg_mul_b;
            reg_partial_sum <= reg_partial_sum;
            reg_bit_idx     <= reg_bit_idx;
        end
    end

    // Pipeline Stage 2: Calculate next partial sum and increment bit index
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_next_partial_sum <= {2*size{1'b0}};
            reg_next_bit_idx     <= 0;
            mul_out              <= {2*size{1'b0}};
        end else if (reg_bit_idx < size) begin
            reg_next_partial_sum <= updated_partial_sum;
            reg_next_bit_idx     <= reg_bit_idx + 1;
            mul_out              <= mul_out; // hold mul_out until done
        end else begin
            // When done, output the final product
            reg_next_partial_sum <= reg_next_partial_sum;
            reg_next_bit_idx     <= reg_next_bit_idx;
            mul_out              <= reg_partial_sum;
        end
    end

endmodule