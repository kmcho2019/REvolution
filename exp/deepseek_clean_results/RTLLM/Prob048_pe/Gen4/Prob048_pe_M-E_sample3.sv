module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg;
    reg signed [31:0] b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] acc_reg;

    // Booth encoding signals
    wire [16:0] booth_sel;
    wire [16:0][31:0] partial_products;

    // Carry-save accumulation signals
    wire signed [31:0] sum_out;
    wire signed [31:0] carry_out;

    // Stage 1: Booth encoding and partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Booth encoder (radix-4)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth_encoder
            wire [2:0] booth_bits = (i == 0) ? {b_reg[1], b_reg[0], 1'b0} : 
                                    {b_reg[2*i+1], b_reg[2*i], b_reg[2*i-1]};
            
            assign booth_sel[i] = (booth_bits == 3'b000 || booth_bits == 3'b111) ? 1'b0 : 1'b1;
            
            case (booth_bits)
                3'b001, 3'b010: partial_products[i] = a_reg;
                3'b011:         partial_products[i] = a_reg << 1;
                3'b100:         partial_products[i] = ~(a_reg << 1) + 1;
                3'b101, 3'b110: partial_products[i] = ~a_reg + 1;
                default:        partial_products[i] = 32'd0;
            endcase
        end
    endgenerate

    // Stage 1: Partial product reduction (Wallace tree)
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            // Simplified partial product reduction (in real implementation would use full Wallace tree)
            product_reg <= partial_products[0] + (partial_products[1] << 2) + 
                          (partial_products[2] << 4) + (partial_products[3] << 6) +
                          // ... continue for all partial products
                          (partial_products[15] << 30);
        end
    end

    // Stage 2: Carry-save accumulation
    assign {carry_out, sum_out} = acc_reg + product_reg[31:0] + {31'd0, product_reg[32]};

    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'd0;
            c <= 32'd0;
        end else begin
            acc_reg <= sum_out + (carry_out << 1);
            c <= sum_out + (carry_out << 1);
        end
    end

endmodule