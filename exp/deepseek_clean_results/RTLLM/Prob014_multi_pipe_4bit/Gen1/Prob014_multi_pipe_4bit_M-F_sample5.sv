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

    // Pipeline stage 1 calculations (sum of first 2 partial products)
    wire [2*size-1:0] stage1_sum = pp[0] + pp[1];
    
    // Pipeline stage 1 register
    reg [2*size-1:0] stage1_reg;

    // Pipeline stage 2 calculations (add pp[2] to stage1 result)
    wire [2*size-1:0] stage2_sum = stage1_reg + pp[2];
    
    // Pipeline stage 2 register
    reg [2*size-1:0] stage2_reg;

    // Final sum calculation (add pp[3] to stage2 result)
    wire [2*size-1:0] final_sum = stage2_reg + pp[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage1_reg <= {(2*size){1'b0}};
            stage2_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: store sum of pp[0] and pp[1]
            stage1_reg <= stage1_sum;

            // Pipeline stage 2: store sum of stage1 and pp[2]
            stage2_reg <= stage2_sum;

            // Final output: store sum of stage2 and pp[3]
            mul_out <= final_sum;
        end
    end

endmodule