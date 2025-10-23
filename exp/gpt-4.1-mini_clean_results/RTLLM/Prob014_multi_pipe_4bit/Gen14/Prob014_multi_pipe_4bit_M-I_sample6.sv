module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by padding MSBs with zeros (size bits)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};
    // ext_mul_b is not used, only mul_b bits are needed directly

    // --- Partial products combinational generation ---
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers: latch partial products ---
    reg [2*size-1:0] stage1_regs [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= partial_products[j];
        end
    end

    // --- Stage 2: sum all registered partial products and register output ---
    reg [2*size-1:0] sum_partial;
    always @(*) begin
        sum_partial = {2*size{1'b0}};
        for (j = 0; j < size; j = j + 1) begin
            sum_partial = sum_partial + stage1_regs[j];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_partial;
        end
    end

endmodule