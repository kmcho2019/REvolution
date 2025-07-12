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
    wire [size-1:0] b = mul_b; // Use mul_b directly for clarity

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial_products[i] = b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products individually
    reg [2*size-1:0] stage1_regs [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= {2*size{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_regs[j] <= partial_products[j];
            end
        end
    end

    // Stage 2 register: sum of stage1_regs partial products
    reg [2*size-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            // Sum all partial products from stage1 registers
            stage2_reg <= stage1_regs[0] + stage1_regs[1] + stage1_regs[2] + stage1_regs[3];
            mul_out    <= stage2_reg;
        end
    end

endmodule