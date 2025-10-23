module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding size zeros at MSB
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar gi;
    generate
        for (gi = 0; gi < size; gi = gi + 1) begin : gen_partials
            assign partial_products[gi] = mul_b[gi] ? (ext_mul_a << gi) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers to latch partial products
    reg [2*size-1:0] stage1_regs [0:size-1];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1)
                stage1_regs[i] <= 0;
        end else begin
            for (i = 0; i < size; i = i + 1)
                stage1_regs[i] <= partial_products[i];
        end
    end

    // Stage 2 registers: sum all stage1 partial products and register output
    reg [2*size-1:0] sum_partial;
    always @(*) begin
        sum_partial = 0;
        for (i = 0; i < size; i = i + 1)
            sum_partial = sum_partial + stage1_regs[i];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= sum_partial;
    end

endmodule