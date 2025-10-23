module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [size-1:0] b = mul_b;

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial_products[i] = b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products explicitly (no arrays)
    reg [2*size-1:0] stage1_reg0;
    reg [2*size-1:0] stage1_reg1;
    reg [2*size-1:0] stage1_reg2;
    reg [2*size-1:0] stage1_reg3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= {2*size{1'b0}};
            stage1_reg1 <= {2*size{1'b0}};
            stage1_reg2 <= {2*size{1'b0}};
            stage1_reg3 <= {2*size{1'b0}};
        end else begin
            stage1_reg0 <= partial_products[0];
            stage1_reg1 <= partial_products[1];
            stage1_reg2 <= partial_products[2];
            stage1_reg3 <= partial_products[3];
        end
    end

    // Stage 2 register: sum partial products registered from stage 1 in pipeline
    reg [2*size-1:0] sum_stage2;

    // To reduce combinational path, sum stage1 regs in pairs first, then add
    wire [2*size-1:0] sum_pair0 = stage1_reg0 + stage1_reg1;
    wire [2*size-1:0] sum_pair1 = stage1_reg2 + stage1_reg3;
    wire [2*size-1:0] total_sum = sum_pair0 + sum_pair1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            sum_stage2 <= total_sum;
            mul_out    <= sum_stage2;
        end
    end

endmodule