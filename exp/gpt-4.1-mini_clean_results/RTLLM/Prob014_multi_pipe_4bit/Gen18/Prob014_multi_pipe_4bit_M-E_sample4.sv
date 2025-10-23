module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand (mul_a) by padding MSBs with zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Internal counter to select multiplier bit
    reg [$clog2(size):0] bit_cnt;  // enough bits to count from 0 to size

    // Register holding accumulator of partial sums (Pipeline Stage 1 register)
    reg [2*size-1:0] acc_reg;

    // Register holding final product (Pipeline Stage 2 register)
    reg [2*size-1:0] prod_reg;

    // Partial product for current multiplier bit
    wire [2*size-1:0] curr_partial_product;
    assign curr_partial_product = mul_b[bit_cnt] ? (ext_mul_a << bit_cnt) : {2*size{1'b0}};

    // Pipeline Stage 1: Accumulate partial products sequentially
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 0;
            acc_reg <= {2*size{1'b0}};
        end else begin
            if (bit_cnt < size) begin
                acc_reg <= acc_reg + curr_partial_product;
                bit_cnt <= bit_cnt + 1;
            end else begin
                // Hold acc_reg value after full accumulation
                acc_reg <= acc_reg;
                bit_cnt <= bit_cnt;
            end
        end
    end

    // Pipeline Stage 2: Register the final product after accumulation done
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prod_reg <= {2*size{1'b0}};
            mul_out  <= {2*size{1'b0}};
        end else begin
            // When bit_cnt == size, move accumulator to stage 2 register and output it
            if (bit_cnt == size) begin
                prod_reg <= acc_reg;
                mul_out  <= prod_reg;
            end else begin
                prod_reg <= prod_reg;
                mul_out  <= mul_out;
            end
        end
    end

endmodule