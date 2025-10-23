module multi_booth_8bit (
    input         clk,
    input         reset,
    input  [7:0]  a,    // multiplicand (signed)
    input  [7:0]  b,    // multiplier   (signed)
    output [15:0] p,    // product output
    output        rdy    // ready signal
);

    // Internal registers
    reg [15:0] product;      // Holds accumulator and multiplier + extra bit for Booth recoding
    reg [8:0]  multiplicand; // 9-bit signed multiplicand (sign-extended)
    reg [3:0]  count;        // Cycle counter (0 to 8)
    reg        ready_reg;

    assign rdy = ready_reg;
    assign p = product[15:0];

    // Extract 3 bits for Booth recoding (bits [2:0] of product)
    wire [2:0] booth_bits = product[2:0];

    // Sign-extend multiplicand to 16 bits for addition/subtraction
    wire signed [15:0] multiplicand_ext = { {7{multiplicand[8]}}, multiplicand };

    // Partial product based on Booth encoding
    wire signed [15:0] partial_product;
    reg  signed [15:0] partial_product_reg;

    always @(*) begin
        case (booth_bits)
            3'b000,
            3'b111: partial_product_reg = 16'sd0;
            3'b001,
            3'b010: partial_product_reg = multiplicand_ext;
            3'b011: partial_product_reg = multiplicand_ext << 1;   // x2 multiplicand
            3'b100: partial_product_reg = - (multiplicand_ext << 1);
            3'b101,
            3'b110: partial_product_reg = -multiplicand_ext;
            default: partial_product_reg = 16'sd0;
        endcase
    end
    assign partial_product = partial_product_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset: load multiplicand (sign extended), load multiplier with extra zero bit appended
            multiplicand <= {a[7], a};          // 9-bit sign-extended multiplicand
            product <= {8'd0, b, 1'b0};        // Product register = upper 8 bits zero + b + 1 bit zero LSB
            count <= 4'd0;
            ready_reg <= 1'b0;
        end else if (!ready_reg) begin
            if (count < 4'd8) begin
                // Add partial product to upper 8 bits of product (accumulator)
                // product[15:8] is accumulator, product[7:0]+1 bit is multiplier + booth bit
                // Sum = accumulator + partial_product
                // Extract accumulator part, add partial product, then combine
                // To avoid width mismatch, cast accumulator to signed 16-bit and add partial_product
                reg signed [15:0] acc;
                acc = {product[15:8], 8'd0} >>> 8; // Extract and sign-extend accumulator upper half
                acc = $signed({product[15:8], 8'd0}) >>> 8; // more explicit sign extension

                acc = $signed({product[15:8], 8'd0}) >>> 8; // but this is tricky, better do:

                // Let's reinterpret accumulator as signed 8 bits sign extended to 16 bits
                reg signed [15:0] acc_signed;
                acc_signed = { {8{product[15]}}, product[15:8] };

                acc_signed = acc_signed + partial_product;

                // Now combine acc_signed upper 8 bits back with product lower bits for next step
                product <= { acc_signed[15:8], product[7:0] } >>> 2; // Arithmetic right shift 2 bits

                count <= count + 1'b1;
            end else begin
                // Done
                ready_reg <= 1'b1;
            end
        end
    end

endmodule