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

    // Partial products generation (combinational)
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers
    reg [2*size-1:0] stage1_sum;
    reg [2*size-1:0] stage1_pp2, stage1_pp3;

    // Pipeline stage 2 registers
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            stage1_sum <= {(2*size){1'b0}};
            stage1_pp2 <= {(2*size){1'b0}};
            stage1_pp3 <= {(2*size){1'b0}};
            stage2_sum <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // First pipeline stage: sum pp0 and pp1, store pp2 and pp3
            stage1_sum <= pp[0] + pp[1];
            stage1_pp2 <= pp[2];
            stage1_pp3 <= pp[3];

            // Second pipeline stage: accumulate results
            stage2_sum <= stage1_sum + stage1_pp2;
            mul_out <= stage2_sum + stage1_pp3;
        end
    end

endmodule