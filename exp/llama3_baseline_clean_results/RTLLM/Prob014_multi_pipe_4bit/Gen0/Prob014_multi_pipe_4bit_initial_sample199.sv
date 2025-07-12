module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    // Extend input signals by adding "size" number of zero bits at the most significant bit positions
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Initialize registers to store intermediate sum values
    reg [2*size-1:0] reg1;
    reg [2*size-1:0] reg2;

    // Initialize product output
    reg [2*size-1:0] mul_out_reg;

    // Generate partial products for each bit position of the multiplier
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_products[i] = (mul_b[i] == 1'b1) ? (ext_mul_a << i) : 'd0;
        end
    endgenerate

    // Add partial products and store in registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 'd0;
            reg2 <= 'd0;
        end else begin
            if (reg2 == 'd0) begin
                reg1 <= partial_products[0];
                for (int j = 1; j < size; j++) begin
                    reg1 <= reg1 + partial_products[j];
                end
            end else begin
                reg2 <= reg1;
                mul_out_reg <= reg2;
            end
        end
    end

    // Update product output
    assign mul_out = mul_out_reg;

endmodule