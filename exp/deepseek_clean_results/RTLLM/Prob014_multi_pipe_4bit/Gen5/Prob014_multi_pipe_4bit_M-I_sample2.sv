module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs (zero-padded)
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products generation (conditional)
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline Stage 1: First level of addition (pp0 + pp1)
    wire [2*size-1:0] sum_stage1 = pp[0] + pp[1];
    reg [2*size-1:0] sum_stage1_reg;

    // Pipeline Stage 2: Second level of addition (sum1 + pp2 + pp3)
    wire [2*size-1:0] sum_stage2 = sum_stage1_reg + pp[2] + pp[3];
    reg [2*size-1:0] sum_stage2_reg;

    // Pipeline registers with proper reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_reg <= {(2*size){1'b0}};
            sum_stage2_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            sum_stage1_reg <= sum_stage1;    // Stage 1 -> Stage 2
            sum_stage2_reg <= sum_stage2;    // Stage 2 -> Output
            mul_out <= sum_stage2_reg;       // Final output
        end
    end

endmodule