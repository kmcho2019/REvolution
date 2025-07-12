module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Stage 1: Partial product generation
    wire [2*size-1:0] pp [0:size-1];
    
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b[i] ? ({ {(size){1'b0}}, mul_a } << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline registers
    reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [2*size-1:0] sum_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= {(2*size){1'b0}};
            pp1_reg <= {(2*size){1'b0}};
            pp2_reg <= {(2*size){1'b0}};
            pp3_reg <= {(2*size){1'b0}};
            sum_stage1 <= {(2*size){1'b0}};
        end else begin
            // Register all partial products
            pp0_reg <= pp[0];
            pp1_reg <= pp[1];
            pp2_reg <= pp[2];
            pp3_reg <= pp[3];
            
            // First stage addition (parallel prefix)
            sum_stage1 <= pp[0] + pp[1] + pp[2] + pp[3];
        end
    end

    // Final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {(2*size){1'b0}};
        end else begin
            mul_out <= sum_stage1;
        end
    end

endmodule