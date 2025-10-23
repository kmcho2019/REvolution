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

    // Partial products generation
    wire [2*size-1:0] pp0 = ext_b[0] ? ext_a : 0;
    wire [2*size-1:0] pp1 = ext_b[1] ? (ext_a << 1) : 0;
    wire [2*size-1:0] pp2 = ext_b[2] ? (ext_a << 2) : 0;
    wire [2*size-1:0] pp3 = ext_b[3] ? (ext_a << 3) : 0;

    // Pipeline stage 1 combinational logic
    wire [2*size-1:0] sum_stage1_comb = pp0 + pp1;
    wire [2*size-1:0] sum_stage2_comb = pp2 + pp3;

    // Pipeline stage 1 registers
    reg [2*size-1:0] sum_stage1_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) sum_stage1_reg <= 0;
        else sum_stage1_reg <= sum_stage1_comb;
    end

    // Pipeline stage 2 registers
    reg [2*size-1:0] sum_stage2_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) sum_stage2_reg <= 0;
        else sum_stage2_reg <= sum_stage2_comb;
    end

    // Final output stage combinational logic
    wire [2*size-1:0] mul_out_comb = sum_stage1_reg + sum_stage2_reg;

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) mul_out <= 0;
        else mul_out <= mul_out_comb;
    end

endmodule