module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // ==========================
    // Level 1 registers: Register extended inputs
    // ==========================
    reg [2*size-1:0] reg_mul_a;
    reg [size-1:0]   reg_mul_b;

    // ==========================
    // Partial products wires (combinational logic)
    // ==========================
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = reg_mul_b[i] ? (reg_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // ==========================
    // Level 2 registers: Register partial products
    // Store all partial products in registers for pipeline level 2
    // ==========================
    reg [2*size-1:0] reg_partial_products [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= 0;
            reg_mul_b <= 0;
            for (j=0; j<size; j=j+1)
                reg_partial_products[j] <= 0;
            mul_out <= 0;
        end else begin
            // Level 1 registers: inputs
            reg_mul_a <= ext_mul_a;
            reg_mul_b <= mul_b;

            // Level 2 registers: partial products
            for (j=0; j<size; j=j+1)
                reg_partial_products[j] <= partial_products[j];

            // mul_out update happens in next always block
        end
    end

    // ==========================
    // Combinational summation of registered partial products
    // ==========================
    wire [2*size-1:0] sum_partial_products;
    assign sum_partial_products = reg_partial_products[0] + reg_partial_products[1] + reg_partial_products[2] + reg_partial_products[3];

    // ==========================
    // Output register stage (mul_out) - register sum of partial products
    // ==========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_partial_products;
        end
    end

endmodule