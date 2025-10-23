module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Partial products generation
    wire [2*size-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = b_ext[i] ? (a_ext << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1: Sum of first two partial products
    reg [2*size-1:0] stage1_sum;
    wire [2*size-1:0] stage1_comb = pp[0] + pp[1];

    // Pipeline stage 2: Sum of last two partial products
    reg [2*size-1:0] stage2_sum;
    wire [2*size-1:0] stage2_comb = pp[2] + pp[3];

    // Final sum register
    reg [2*size-1:0] final_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= 0;
            stage2_sum <= 0;
            final_sum <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage
            stage1_sum <= stage1_comb;
            
            // Second pipeline stage
            stage2_sum <= stage2_comb;
            
            // Final addition stage
            final_sum <= stage1_sum + stage2_sum;
            mul_out <= final_sum;
        end
    end

endmodule