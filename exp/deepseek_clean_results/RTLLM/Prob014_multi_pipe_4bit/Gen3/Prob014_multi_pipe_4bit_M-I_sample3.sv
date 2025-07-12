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

    // Partial products with clock gating
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            // Clock gating for power optimization
            wire pp_enable = ext_b[i] && rst_n;
            assign pp[i] = pp_enable ? (ext_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline stage 1: Carry-save addition (narrower sums)
    wire [size+0:0] sum01 = pp[0][size:0] + pp[1][size:0];
    wire [size+1:0] sum23 = pp[2][size+1:0] + pp[3][size+1:0];
    
    // Pipeline stage 1 registers (optimized width)
    reg [size+0:0] sum01_reg;
    reg [size+1:0] sum23_reg;

    // Pipeline stage 2: Intermediate addition
    wire [size+2:0] sum_stage2 = {sum23_reg, 1'b0} + {{2{1'b0}}, sum01_reg};
    
    // Pipeline stage 2 registers
    reg [size+2:0] sum_stage2_reg;

    // Pipeline stage 3: Final addition
    wire [2*size-1:0] final_sum = sum_stage2_reg + 
                                 {{size-3{1'b0}}, pp[3][2*size-1:size+2]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            sum01_reg <= {(size+1){1'b0}};
            sum23_reg <= {(size+2){1'b0}};
            sum_stage2_reg <= {(size+3){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: store carry-save sums
            sum01_reg <= sum01;
            sum23_reg <= sum23;

            // Pipeline stage 2: store intermediate sum
            sum_stage2_reg <= sum_stage2;

            // Final output: store final sum
            mul_out <= final_sum;
        end
    end

endmodule