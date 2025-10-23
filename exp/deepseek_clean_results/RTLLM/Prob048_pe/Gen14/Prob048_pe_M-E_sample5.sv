module pe #(
    parameter WIDTH = 32,
    parameter PIPELINE = 1  // 0 for combinational, 1 for pipelined
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [2*WIDTH-1:0] product_reg;
    reg signed [WIDTH-1:0] acc_reg;

    // Booth encoding signals
    wire [WIDTH/2:0] booth_select;
    wire [2*WIDTH-1:0] partial_products [0:WIDTH/2];

    // Generate Booth encoded partial products
    genvar i;
    generate
        for (i = 0; i <= WIDTH/2; i = i+1) begin : booth
            // Booth encoder logic (simplified for illustration)
            assign booth_select[i] = (i == 0) ? b[1:0] : b[2*i+1:2*i-1];
            
            // Partial product selection
            always @(*) begin
                case (booth_select[i])
                    3'b000, 3'b111: partial_products[i] = 0;
                    3'b001, 3'b010: partial_products[i] = a << (2*i);
                    3'b011:         partial_products[i] = a << (2*i+1);
                    3'b100:         partial_products[i] = -a << (2*i+1);
                    3'b101, 3'b110: partial_products[i] = -a << (2*i);
                endcase
            end
        end
    endgenerate

    // Carry-save adder tree
    wire [2*WIDTH-1:0] product;
    generate
        if (WIDTH == 32) begin
            // 3:2 compressor tree for 32-bit (simplified)
            wire [2*WIDTH-1:0] sum1, carry1;
            csa32 csa1 (
                .a(partial_products[0]),
                .b(partial_products[1]),
                .c(partial_products[2]),
                .sum(sum1),
                .carry(carry1)
            );
            // Additional CSA stages would follow...
            assign product = sum1 + (carry1 << 1);
        end
    endgenerate

    // Dynamic clock gating
    wire clk_en = |a || |b || |c;
    wire gated_clk = clk & clk_en;

    // Pipeline control
    generate
        if (PIPELINE) begin
            always @(posedge gated_clk or posedge rst) begin
                if (rst) begin
                    a_reg <= 0;
                    b_reg <= 0;
                    product_reg <= 0;
                    acc_reg <= 0;
                end else begin
                    a_reg <= a;
                    b_reg <= b;
                    product_reg <= product;
                    acc_reg <= acc_reg + product_reg[WIDTH-1:0];
                end
            end
            assign c = acc_reg;
        end else begin
            always @(posedge gated_clk or posedge rst) begin
                if (rst) begin
                    c <= 0;
                end else begin
                    c <= c + product[WIDTH-1:0];
                end
            end
        end
    endgenerate

    // Optional saturation logic
    // always_comb begin
    //     if (product > 2**(WIDTH-1)-1)
    //         c_sat = 2**(WIDTH-1)-1;
    //     else if (product < -2**(WIDTH-1))
    //         c_sat = -2**(WIDTH-1);
    //     else
    //         c_sat = product[WIDTH-1:0];
    // end

endmodule

// Carry-save adder module (example for 3:2 compression)
module csa32 (
    input [63:0] a, b, c,
    output [63:0] sum, carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule