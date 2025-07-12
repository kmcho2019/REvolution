module multi_pipe_4bit #(parameter size = 4) (
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally (wires)
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers stage 1: register partial products as an array for compactness
    reg [2*size-1:0] stage1_regs [size-1:0];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_regs[idx] <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_regs[idx] <= partial_products[idx];
            
            // Balanced adder tree combinational inside always block
            // Level 1 sums
            // For size=4, sum pairs: 0+1 and 2+3
            // If size changes, this needs adaptation; here fixed for 4
            reg [2*size-1:0] sum_lvl1_0, sum_lvl1_1;
            sum_lvl1_0 = stage1_regs[0] + stage1_regs[1];
            sum_lvl1_1 = stage1_regs[2] + stage1_regs[3];

            // Final sum
            mul_out <= sum_lvl1_0 + sum_lvl1_1;
        end
    end

endmodule