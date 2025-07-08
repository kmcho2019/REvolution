module multi_pipe_4bit #
(
    parameter size = 4
)
(
    input                   clk,
    input                   rst_n,
    input   [size-1:0]      mul_a,
    input   [size-1:0]      mul_b,
    output  reg [2*size-1:0] mul_out
);

    // Extended inputs (size*2 bits), zero-extended at MSB side
    wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_b = { {size{1'b0}}, mul_b }; // used only for clarity, not needed for logic

    // Partial products: For each bit of mul_b, if bit is 1 => (ext_a << i), else 0
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for intermediate sums - two levels
    // Level 1 registers: store sums of partial products in pairs
    // size=4, partial_products: 4 elements
    // sum pairs: (pp0 + pp1), (pp2 + pp3)
    reg [2*size-1:0] reg_level1_0, reg_level1_1;

    // Level 2 register: sum of level1 registers
    reg [2*size-1:0] reg_level2;

    // Final output register (mul_out) will hold the final product

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reg_level1_0 <= {2*size{1'b0}};
            reg_level1_1 <= {2*size{1'b0}};
            reg_level2   <= {2*size{1'b0}};
            mul_out      <= {2*size{1'b0}};
        end
        else begin
            // Level 1 registers get sums of partial products
            reg_level1_0 <= partial_products[0] + partial_products[1];
            reg_level1_1 <= partial_products[2] + partial_products[3];

            // Level 2 register sums outputs of level 1 (registered, so from previous clock)
            reg_level2   <= reg_level1_0 + reg_level1_1;

            // Final output register sums the level 2 register
            mul_out      <= reg_level2;
        end
    end

endmodule