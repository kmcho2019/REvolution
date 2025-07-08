module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,    // multiplicand
    input [7:0] b,    // multiplier
    output reg [15:0] p,
    output reg rdy
);

    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg [17:0] product;               // 18-bit register: product + multiplier bits + extra bit for booth
    reg [4:0] ctr;                   // counter for iterations

    // Booth radix-4 groups bits as 3 bits per iteration, we need 4 iterations (8 bits / 2)
    // So counter goes from 0 to 4 (exclusive)

    // Extract the 3 LSB bits of product for Booth encoding:
    // product[2:0]

    // Booth encoding table for radix-4:
    // 000 -> 0
    // 001 -> +1 * multiplicand
    // 010 -> +1 * multiplicand
    // 011 -> +2 * multiplicand
    // 100 -> -2 * multiplicand
    // 101 -> -1 * multiplicand
    // 110 -> -1 * multiplicand
    // 111 -> 0

    // On each cycle, process product[2:0], then arithmetic right shift product by 2 bits.

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset:
            // multiplicand <= sign-extended a
            multiplicand <= { {8{a[7]}}, a };
            // Initialize product with multiplier in the lower 8 bits, and 2 zero bits at LSB for Booth
            // and 8 upper bits zeroed
            product <= {10'b0, b, 1'b0}; // 18 bits: [17:0], 8 bits multiplier in bits [8:1], LSB bit0 zero
            p <= 0;
            ctr <= 0;
            rdy <= 0;
        end else if (!rdy) begin
            // If not done
            if (ctr < 4) begin
                // Booth encoding bits are product[2:0]
                case (product[2:0])
                    3'b000, 3'b111: begin
                        // 0: no operation
                        // do nothing
                    end
                    3'b001, 3'b010: begin
                        // +1 * multiplicand
                        product[17:2] = product[17:2] + multiplicand;
                    end
                    3'b011: begin
                        // +2 * multiplicand
                        product[17:2] = product[17:2] + (multiplicand <<< 1);
                    end
                    3'b100: begin
                        // -2 * multiplicand
                        product[17:2] = product[17:2] - (multiplicand <<< 1);
                    end
                    3'b101, 3'b110: begin
                        // -1 * multiplicand
                        product[17:2] = product[17:2] - multiplicand;
                    end
                endcase
                // Arithmetic right shift by 2 bits (keep sign extension)
                // product is 18 bits signed, so preserve sign in bits [17:16]
                // We shift right by 2
                product = {product[17], product[17], product[17:2]};

                ctr <= ctr + 1;
            end else begin
                // Done
                p <= product[17:2]; // final 16-bit product
                rdy <= 1;
            end
        end
    end

endmodule