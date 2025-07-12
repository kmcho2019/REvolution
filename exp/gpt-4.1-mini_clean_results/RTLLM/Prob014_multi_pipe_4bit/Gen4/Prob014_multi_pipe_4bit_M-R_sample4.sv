module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Combinational sums for stage 1 (sum pairs)
    wire [2*size-1:0] sum_stage1_0 = partial[0] + partial[1];
    wire [2*size-1:0] sum_stage1_1 = partial[2] + partial[3];

    // Pipeline registers for stage 1 results
    reg [2*size-1:0] stage1_reg_0, stage1_reg_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg_0 <= 0;
            stage1_reg_1 <= 0;
        end else begin
            stage1_reg_0 <= sum_stage1_0;
            stage1_reg_1 <= sum_stage1_1;
        end
    end

    // Combinational sum for stage 2 (sum of stage1 registers)
    wire [2*size-1:0] sum_stage2 = stage1_reg_0 + stage1_reg_1;

    // Pipeline register for final sum
    reg [2*size-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage2_reg <= 0;
        else
            stage2_reg <= sum_stage2;
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= stage2_reg;
    end

endmodule