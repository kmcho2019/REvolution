module multi_pipe_4bit #(parameter size = 4) (
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [2*size-1:0]    mul_out
);

    // Extended width
    localparam ext_size = size * 2; // 8 for size=4

    // ----------------------------------------
    // Stage 0: Register inputs with zero extension
    // ----------------------------------------
    reg [ext_size-1:0] reg_mul_a;  // mul_a extended with size zeros at MSB
    reg [size-1:0]     reg_mul_b;  // multiplier registered as is

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {ext_size{1'b0}};
            reg_mul_b <= {size{1'b0}};
        end else begin
            reg_mul_a <= {{size{1'b0}}, mul_a}; // size MSB zeros + mul_a at LSB
            reg_mul_b <= mul_b;
        end
    end

    // ----------------------------------------
    // Stage 1: Generate and register partial products
    // ----------------------------------------
    // Each partial product has width ext_size bits (8 bits)
    reg [ext_size-1:0] partial_products_reg [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            wire [ext_size-1:0] shifted_a = reg_mul_a << i;
            wire selected = reg_mul_b[i];
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_products_reg[i] <= {ext_size{1'b0}};
                end else begin
                    partial_products_reg[i] <= selected ? shifted_a : {ext_size{1'b0}};
                end
            end
        end
    endgenerate

    // ----------------------------------------
    // Stage 2: Sum partial products and register output
    // ----------------------------------------
    // Sum partial products combinationally
    wire [ext_size-1:0] sum_partial_products = 
        partial_products_reg[0] +
        partial_products_reg[1] +
        partial_products_reg[2] +
        partial_products_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {(2*size){1'b0}};
        end else begin
            mul_out <= sum_partial_products;
        end
    end

endmodule