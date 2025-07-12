module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers (stores sum of first 2 partial products)
    reg [2*size-1:0] stage1_reg;

    // Pipeline stage 2 registers (stores sum of first 3 partial products)
    reg [2*size-1:0] stage2_reg;

    // Final sum (sum of all partial products)
    wire [2*size-1:0] final_sum = stage2_reg + pp[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage1_reg <= {(2*size){1'b0}};
            stage2_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: sum of pp[0] and pp[1]
            stage1_reg <= pp[0] + pp[1];

            // Pipeline stage 2: add pp[2] to previous sum
            stage2_reg <= stage1_reg + pp[2];

            // Final output: add pp[3] to previous sum
            mul_out <= final_sum;
        end
    end

endmodule