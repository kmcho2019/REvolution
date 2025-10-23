module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs (with size zeros at MSB)
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a }; // 8-bit: upper 4 bits zero
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for(i = 0; i < size; i = i +1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First level registers (two registers to sum partial products in pairs)
    reg [2*size-1:0] reg_level1_0;
    reg [2*size-1:0] reg_level1_1;

    // Second level register (sum of level 1 registers)
    reg [2*size-1:0] reg_level2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_level1_0 <= 0;
            reg_level1_1 <= 0;
            reg_level2   <= 0;
            mul_out      <= 0;
        end else begin
            // Level 1: sum partial_products[0] + partial_products[1], partial_products[2] + partial_products[3]
            reg_level1_0 <= partial_products[0] + partial_products[1];
            reg_level1_1 <= partial_products[2] + partial_products[3];
            // Level 2: sum reg_level1_0 + reg_level1_1
            reg_level2 <= reg_level1_0 + reg_level1_1;
            // Output product
            mul_out <= reg_level2;
        end
    end

endmodule