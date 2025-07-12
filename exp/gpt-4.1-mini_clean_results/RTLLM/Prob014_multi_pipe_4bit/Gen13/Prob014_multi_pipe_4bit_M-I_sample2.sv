module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
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

    // Stage 1 registers: store partial products
    reg [2*size-1:0] stage1_regs [size-1:0];

    // Stage 2 registers: store sums of pairs of partial products
    // For size=4, we have two sums: (0+1) and (2+3)
    reg [2*size-1:0] stage2_reg0;
    reg [2*size-1:0] stage2_reg1;

    // Combinational wires for sums between pipeline stages
    wire [2*size-1:0] sum_stage2_0 = stage1_regs[0] + stage1_regs[1];
    wire [2*size-1:0] sum_stage2_1 = stage1_regs[2] + stage1_regs[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset stage1 registers and stage2 registers and output
            stage1_regs[0] <= {2*size{1'b0}};
            stage1_regs[1] <= {2*size{1'b0}};
            stage1_regs[2] <= {2*size{1'b0}};
            stage1_regs[3] <= {2*size{1'b0}};
            stage2_reg0    <= {2*size{1'b0}};
            stage2_reg1    <= {2*size{1'b0}};
            mul_out        <= {2*size{1'b0}};
        end else begin
            // Stage 1: register partial products
            stage1_regs[0] <= partial_products[0];
            stage1_regs[1] <= partial_products[1];
            stage1_regs[2] <= partial_products[2];
            stage1_regs[3] <= partial_products[3];

            // Stage 2: register sums of pairs from stage1_regs
            stage2_reg0 <= sum_stage2_0;
            stage2_reg1 <= sum_stage2_1;

            // Final output: sum of stage2_reg0 and stage2_reg1 registered next cycle
            // To ensure proper pipelining, output update happens in next clock cycle
            // So the final output should be registered in a separate always block for clarity.
        end
    end

    // Separate always block for final addition and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_reg0 + stage2_reg1;
        end
    end

endmodule