module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with size zeros at MSB
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS
            assign pp[i] = ext_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers (sum of first two partial products)
    reg [2*size-1:0] stage1_reg;
    wire [2*size-1:0] stage1_sum = pp[0] + pp[1];

    // Pipeline stage 2 registers (sum of next two partial products)
    reg [2*size-1:0] stage2_reg;
    wire [2*size-1:0] stage2_sum = pp[2] + pp[3];

    // Final sum register
    reg [2*size-1:0] final_sum_reg;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= {2*size{1'b0}};
            stage2_reg <= {2*size{1'b0}};
            final_sum_reg <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            // First pipeline stage
            stage1_reg <= stage1_sum;
            
            // Second pipeline stage
            stage2_reg <= stage2_sum;
            
            // Final sum (after both pipeline stages complete)
            final_sum_reg <= stage1_reg + stage2_reg;
            
            // Output
            mul_out <= final_sum_reg;
        end
    end

endmodule