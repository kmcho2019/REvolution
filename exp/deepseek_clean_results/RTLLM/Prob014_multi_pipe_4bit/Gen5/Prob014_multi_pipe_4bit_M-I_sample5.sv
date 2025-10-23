module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = 2*size;

    // Extended versions of inputs
    wire [ext_size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [ext_size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Pipeline Stage 1: First two partial products
    reg [ext_size-1:0] pp0_reg, pp1_reg;
    wire [ext_size-1:0] pp0 = ext_b[0] ? ext_a : {ext_size{1'b0}};
    wire [ext_size-1:0] pp1 = ext_b[1] ? (ext_a << 1) : {ext_size{1'b0}};
    wire [ext_size-1:0] sum_stage1 = pp0 + pp1;

    // Pipeline Stage 2: Next two partial products and intermediate sum
    reg [ext_size-1:0] pp2_reg, pp3_reg, sum_stage1_reg;
    wire [ext_size-1:0] pp2 = ext_b[2] ? (ext_a << 2) : {ext_size{1'b0}};
    wire [ext_size-1:0] pp3 = ext_b[3] ? (ext_a << 3) : {ext_size{1'b0}};
    wire [ext_size-1:0] sum_stage2 = sum_stage1_reg + pp2_reg + pp3_reg;

    // Pipeline registers with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            pp0_reg <= {ext_size{1'b0}};
            pp1_reg <= {ext_size{1'b0}};
            pp2_reg <= {ext_size{1'b0}};
            pp3_reg <= {ext_size{1'b0}};
            sum_stage1_reg <= {ext_size{1'b0}};
            mul_out <= {ext_size{1'b0}};
        end else begin
            // Stage 1 registers
            pp0_reg <= pp0;
            pp1_reg <= pp1;
            
            // Stage 2 registers
            pp2_reg <= pp2;
            pp3_reg <= pp3;
            sum_stage1_reg <= sum_stage1;
            
            // Final output
            mul_out <= sum_stage2;
        end
    end

endmodule