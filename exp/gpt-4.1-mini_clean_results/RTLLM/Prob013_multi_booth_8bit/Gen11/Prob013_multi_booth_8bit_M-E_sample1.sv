module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplicand
    input      [7:0]   b,       // multiplier
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    reg [2:0] state;             // state counter (0 to 4)
    reg signed [16:0] product;   // combined product/multiplier register (17 bits)
    reg signed [15:0] multiplicand;        // signed multiplicand (16 bits)
    reg signed [15:0] multiplicand_2x;     // multiplicand * 2 (for Booth encoding)
    reg signed [15:0] multiplicand_neg;    // -multiplicand
    reg signed [15:0] multiplicand_neg_2x; // -2 * multiplicand

    // Booth encoding function: returns addition to product based on 3-bit booth_code
    // booth_code: {product[1:0], product[-1]} (the last bit is the previous LSB)
    // Encoding table for Radix-4:
    // 000 -> 0
    // 001 -> +multiplicand
    // 010 -> +multiplicand
    // 011 -> +2*multiplicand
    // 100 -> -2*multiplicand
    // 101 -> -multiplicand
    // 110 -> -multiplicand
    // 111 -> 0
    function signed [15:0] booth_calc;
        input [2:0] booth_code;
        begin
            case (booth_code)
                3'b000,
                3'b111: booth_calc = 16'sd0;
                3'b001,
                3'b010: booth_calc = multiplicand;
                3'b011: booth_calc = multiplicand_2x;
                3'b100: booth_calc = multiplicand_neg_2x;
                3'b101,
                3'b110: booth_calc = multiplicand_neg;
                default: booth_calc = 16'sd0;
            endcase
        end
    endfunction

    wire [2:0] booth_code; // Current booth code bits

    assign booth_code = {product[1:0], product[0]}; // product[-1] == product[0] for initial cycle

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplicand and its multiples
            multiplicand       <= {a[7], a}; // sign-extend to 16 bits
            multiplicand_2x    <= {a[7], a} <<< 1; // *2
            multiplicand_neg   <= -{a[7], a};
            multiplicand_neg_2x<= -( {a[7], a} <<< 1 );
            // Initialize product register:
            // product[16:1] = multiplier sign-extended (16 bits)
            // product[0] = 0 (extra bit for Booth)
            product <= { {8{b[7]}}, b, 1'b0 };
            // Reset counter and ready
            state <= 0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (rdy == 1'b0) begin
            // Perform Booth cycle
            // Extract booth_code bits:
            // Here we use product[2:0] for booth_code: bits [1:0] + bit[-1]
            // Since bit[-1] not directly accessible, we use product[0] again as a trick
            // Actually, proper booth_code is product[1:0] plus product[-1], which is product bit right shifted by 1 for previous LSB
            // To keep it correct, shift product left or right carefully

            // Calculate the partial addition
            // add the booth_calc shifted left by 0 bits since product holds accumulator already shifted

            // Apply the addition/subtraction to the upper bits of product:
            // product[16:1] holds accumulator and multiplier bits
            // Only product[16:1] will be added

            // First compute addition term for current booth_code
            // Since product is 17 bits, upper 16 bits are partial product, lower bits hold multiplier and booth bit

            signed [16:0] addition_term;
            addition_term = { {1{booth_calc(booth_code)[15]}}, booth_calc(booth_code) }; // sign extend to 17 bits

            // Add partial product and addition_term at upper bits [16:1]
            product[16:1] <= product[16:1] + addition_term;

            // Arithmetic shift right product by 2 bits (for next iteration)
            // Use arithmetic shift right preserving sign bit for product[16:1]
            product <= {product[16], product[16:2]};

            // Update counter
            state <= state + 1'b1;

            if (state == 4) begin
                // Last cycle done
                rdy <= 1'b1;
                p <= product[16:1]; // Final product is bits 16 down to 1
            end
        end
    end

endmodule