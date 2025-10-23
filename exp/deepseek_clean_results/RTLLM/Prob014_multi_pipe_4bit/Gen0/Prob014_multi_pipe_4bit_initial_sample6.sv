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

    // Partial products
    wire [2*size-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = b_ext[i] ? (a_ext << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers
    reg [2*size-1:0] sum_stage1;
    reg [2*size-1:0] pp2_reg;
    reg [2*size-1:0] pp3_reg;

    // Pipeline stage 2 registers
    reg [2*size-1:0] sum_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            sum_stage1 <= 0;
            pp2_reg <= 0;
            pp3_reg <= 0;
            sum_stage2 <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage: sum pp[0] + pp[1], store pp[2] and pp[3]
            sum_stage1 <= pp[0] + pp[1];
            pp2_reg <= pp[2];
            pp3_reg <= pp[3];

            // Second pipeline stage: add previous sum with stored partial products
            sum_stage2 <= sum_stage1 + pp2_reg + pp3_reg;

            // Final output
            mul_out <= sum_stage2;
        end
    end

endmodule