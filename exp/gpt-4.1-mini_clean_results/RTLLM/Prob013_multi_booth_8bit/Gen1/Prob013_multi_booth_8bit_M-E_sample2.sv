module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,          // Multiplicand
    input [7:0] b,          // Multiplier
    output reg [15:0] p,    // Product
    output reg rdy
);

    // Internal registers
    reg [16:0] partial_prod;      // {accumulator[16:0]} = upper 16 bits product + 1 bit Booth prev bit
    reg [8:0] multiplicand_ext;   // sign-extended multiplicand (9 bits)
    reg [3:0] count;              // 4 cycles for 8-bit radix-4 Booth (2 bits per cycle)

    // Booth encoding function: input is 3 bits (multiplier bits + prev bit)
    // Output: signed value multiplier for multiplicand:
    // 000 or 111 => 0
    // 001 or 010 => +1
    // 011 => +2
    // 100 => -2
    // 101 or 110 => -1
    function signed [1:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 2'd0;
                3'b001, 3'b010: booth_decode = 2'd1;
                3'b011:        booth_decode = 2'd2;
                3'b100:        booth_decode = -2;
                3'b101, 3'b110: booth_decode = -1;
                default:       booth_decode = 2'd0; // Safety default
            endcase
        end
    endfunction

    // Shift right arithmetic for partial_prod register by 2 bits:
    // partial_prod is 17 bits signed, so sign-extend top bits when shifting.
    wire signed [16:0] partial_prod_s = partial_prod;
    wire signed [16:0] shifted_partial_prod = (partial_prod_s >>> 2);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize:
            // multiplicand sign-extended to 9 bits
            multiplicand_ext <= {a[7], a};  // 9-bit signed a
            // partial product initialized with multiplier (b) extended with prev bit 0 at LSB
            // partial_prod layout: [16:9] accumulator, [8:1] multiplier bits, [0] prev bit for Booth
            partial_prod <= {8'd0, b, 1'b0};
            count <= 0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (rdy == 0) begin
            if (count < 4) begin
                // Decode the lowest 3 bits: bits [2:0] = partial_prod[2:0]
                // Actually bits [2:0] of partial_prod:
                // bits 1 and 0 correspond to multiplier bits
                // bit 0 is previous bit, so bits are partial_prod[2], partial_prod[1], partial_prod[0]
                // We'll select bits [2:0] from partial_prod register (lower 3 bits)
                // But partial_prod has layout:
                // LSB is prev bit (bit 0)
                // bits 1 and 2 are multiplier bits for current radix-4 group
                // So the bits to decode are partial_prod[2:0]
                // Let's define:
                wire [2:0] booth_bits = partial_prod[2:0];

                // Get multiplier from booth_decode function
                // For code clarity, assign booth_bits to a variable
                reg signed [3:0] op;  // -2,-1,0,1,2

                op = booth_decode(booth_bits);

                // Calculate op * multiplicand_ext
                // multiplicand_ext is 9 bits signed, op is 2 bits signed (extended to 4 bits)
                // So prod_temp is signed [13:0] (9 + 4 bits)
                reg signed [13:0] prod_temp;
                prod_temp = op * multiplicand_ext;

                // Add prod_temp to upper 16 bits of partial_prod (bits [16:1])
                // partial_prod[16:1] is 16 bits signed
                // Sign-extend partial_prod upper bits to 17 bits signed before addition
                reg signed [16:0] upper_part;
                upper_part = partial_prod[16:1];

                // Add prod_temp (14 bits signed) to upper_part (16 bits signed)
                // Extend prod_temp to 17 bits signed for addition
                reg signed [16:0] prod_temp_ext;
                prod_temp_ext = {{3{prod_temp[13]}}, prod_temp};

                upper_part = upper_part + prod_temp_ext;

                // Update partial_prod after addition
                partial_prod <= {upper_part, partial_prod[0]};

                // Shift arithmetic right by 2 bits for next iteration
                partial_prod <= shifted_partial_prod;

                count <= count + 1'b1;

                if (count == 3) begin
                    // After last iteration, set output
                    p <= shifted_partial_prod[16:1];  // upper 16 bits are the product
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule