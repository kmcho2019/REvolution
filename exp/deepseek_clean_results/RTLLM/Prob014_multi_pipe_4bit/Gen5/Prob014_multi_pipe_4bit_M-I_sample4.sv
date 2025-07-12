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

    // Pipeline Stage 0: Partial products with clock gating
    reg [2*size-1:0] pp [0:size-1];
    integer j;
    always @(*) begin
        for (j = 0; j < size; j = j + 1) begin
            pp[j] = ext_b[j] ? (ext_a << j) : {(2*size){1'b0}};
        end
    end

    // Pipeline Stage 1: First level of addition (pp0+pp1 and pp2+pp3)
    reg [2*size-1:0] sum01_reg, sum23_reg;
    wire [2*size-1:0] sum01 = pp[0] + pp[1];
    wire [2*size-1:0] sum23 = pp[2] + pp[3];

    // Pipeline Stage 2: Second level of addition (sum01 + sum23)
    reg [2*size-1:0] sum_stage2;
    wire [2*size-1:0] sum_final = sum01_reg + sum23_reg;

    // Pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= {(2*size){1'b0}};
            sum23_reg <= {(2*size){1'b0}};
            sum_stage2 <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Stage 1 registers
            sum01_reg <= sum01;
            sum23_reg <= sum23;
            
            // Stage 2 register
            sum_stage2 <= sum_final;
            
            // Final output
            mul_out <= sum_stage2;
        end
    end

endmodule