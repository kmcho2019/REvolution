module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] c_acc;

    // Booth encoder signals
    wire [16:0] booth_select;
    wire [15:0][31:0] partial_products;

    // Carry-save accumulator
    reg [31:0] sum, carry;

    // Zero detection for power optimization
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire skip_mult = a_zero | b_zero;

    // Booth encoding (stage 1)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [2:0] booth_bits = (i == 0) ? {b_reg[1], b_reg[0], 1'b0} : 
                                             {b_reg[2*i+1], b_reg[2*i], b_reg[2*i-1]};
            
            always @(*) begin
                case (booth_bits)
                    3'b001, 3'b010: partial_products[i] = a_reg;
                    3'b011:         partial_products[i] = a_reg << 1;
                    3'b100:         partial_products[i] = ~(a_reg << 1) + 1;
                    3'b101, 3'b110: partial_products[i] = ~a_reg + 1;
                    default:        partial_products[i] = 32'b0;
                endcase
            end
        end
    endgenerate

    // Pipeline stage 1: Register inputs
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Pipeline stage 2: Carry-save addition
    always @(posedge clk) begin
        if (rst) begin
            sum <= 32'b0;
            carry <= 32'b0;
        end else begin
            if (skip_mult) begin
                sum <= 32'b0;
                carry <= 32'b0;
            end else begin
                // Simplified CSA tree (actual implementation would have more stages)
                sum <= partial_products[0] + partial_products[1];
                carry <= (partial_products[0] & partial_products[1]) << 1;
            end
        end
    end

    // Pipeline stage 3: Final accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
            c_acc <= 32'b0;
        end else begin
            if (skip_mult) begin
                product_reg <= 64'b0;
            end else begin
                product_reg <= sum + carry;  // Final carry propagation
            end
            
            // Accumulate with saturation
            if (product_reg[63:32] == 32'b0 || product_reg[63:32] == 32'hFFFFFFFF) begin
                c_acc <= c_acc + product_reg[31:0];
            end else begin
                c_acc <= (product_reg[63]) ? 32'h80000000 : 32'h7FFFFFFF;
            end
            
            c <= c_acc;
        end
    end

endmodule