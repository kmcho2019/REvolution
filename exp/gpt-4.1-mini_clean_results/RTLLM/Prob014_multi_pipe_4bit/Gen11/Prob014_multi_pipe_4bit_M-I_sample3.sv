module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Internal registers
    reg [2*size-1:0] stage1_accum; // Accumulate partial products here
    reg [2*size-1:0] stage2_reg;   // Final product register
    reg [$clog2(size+1)-1:0] bit_idx;  // Bit index counter, from 0 to size

    // Sequential process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_accum <= {2*size{1'b0}};
            stage2_reg   <= {2*size{1'b0}};
            mul_out      <= {2*size{1'b0}};
            bit_idx      <= 0;
        end else begin
            if (bit_idx < size) begin
                // For current bit_idx, add partial product if mul_b[bit_idx] == 1
                if (mul_b[bit_idx]) begin
                    stage1_accum <= stage1_accum + (a_ext << bit_idx);
                end else begin
                    stage1_accum <= stage1_accum;
                end
                bit_idx <= bit_idx + 1;
            end else begin
                // Completed processing all bits, latch final product
                stage2_reg <= stage1_accum;
                mul_out    <= stage2_reg;
                // Reset accumulator and bit_idx for next multiplication
                stage1_accum <= {2*size{1'b0}};
                bit_idx <= 0;
            end
        end
    end

endmodule