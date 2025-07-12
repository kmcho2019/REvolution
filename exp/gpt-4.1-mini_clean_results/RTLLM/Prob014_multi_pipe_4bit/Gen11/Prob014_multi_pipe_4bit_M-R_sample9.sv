module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand with size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: each partial product registered individually
    reg [2*size-1:0] pp_reg0, pp_reg1, pp_reg2, pp_reg3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg0 <= 0;
            pp_reg1 <= 0;
            pp_reg2 <= 0;
            pp_reg3 <= 0;
        end else begin
            pp_reg0 <= partial_products[0];
            pp_reg1 <= partial_products[1];
            pp_reg2 <= partial_products[2];
            pp_reg3 <= partial_products[3];
        end
    end

    // Balanced adder tree for summing the four partial products combinationally
    wire [2*size-1:0] sum_stage1_0;
    wire [2*size-1:0] sum_stage1_1;
    wire [2*size-1:0] sum_final;

    assign sum_stage1_0 = pp_reg0 + pp_reg1;
    assign sum_stage1_1 = pp_reg2 + pp_reg3;
    assign sum_final = sum_stage1_0 + sum_stage1_1;

    // Stage 2 register: holds final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_final;
        end
    end

endmodule