module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,        // multiplicand
    input      [7:0]   b,        // multiplier
    output reg [15:0]  p,        // product
    output reg         rdy       // ready flag
);

    // Radix-4 Booth encoding requires 3 bits per cycle (2 bits + 1 overlap)
    // We'll process 8 cycles (16 bits / 2 bits per cycle)
    // Extend multiplier by 1 LSB zero for safe overlapping bits

    // Internal registers
    reg [16:0] multiplier_ext;   // multiplier extended with 1 zero LSB bit
    reg signed [33:0] product;   // wide enough for shifted sum (+ sign bits)
    reg signed [16:0] multiplicand_ext; // sign-extended multiplicand 17-bit
    reg [3:0] ctr;               // 4-bit counter 0..7 for 8 cycles

    // Wires for Booth encoding
    reg signed [16:0] pp;        // partial product for current cycle
    reg [2:0] booth_bits;        // current 3-bit group for encoding

    // Function to generate partial product based on Booth encoding bits
    function signed [16:0] booth_decode;
        input [2:0] bits;
        input signed [16:0] mcand;
        begin
            case (bits)
                3'b000,
                3'b111: booth_decode = 17'sd0;          // 0
                3'b001,
                3'b010: booth_decode = mcand;            // +1 * mcand
                3'b011: booth_decode = mcand <<< 1;      // +2 * mcand
                3'b100: booth_decode = -(mcand <<< 1);   // -2 * mcand
                3'b101,
                3'b110: booth_decode = -mcand;           // -1 * mcand
                default: booth_decode = 17'sd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Sign extend multiplier (b) and multiplicand (a)
            multiplier_ext   <= {b, 1'b0};          // 8 bits multiplier + 1 LSB zero = 9 bits
            multiplicand_ext <= {{9{a[7]}}, a};    // sign extend to 17 bits
            product          <= 34'sd0;
            ctr              <= 4'd0;
            p                <= 16'd0;
            rdy              <= 1'b0;
        end else if (!rdy) begin
            // Calculate the current Booth bits from multiplier_ext
            booth_bits = multiplier_ext[2:0];

            // Compute partial product
            pp = booth_decode(booth_bits, multiplicand_ext);

            // Shift the partial product by 2*ctr bits (shift left by 2 bits per cycle)
            // and accumulate in product
            product <= product + (pp <<< (ctr << 1));

            // Shift multiplier_ext right by 2 bits for next cycle's booth bits
            multiplier_ext <= multiplier_ext >> 2;

            // Increment counter
            ctr <= ctr + 1;

            // When ctr reaches 8, multiplication done
            if (ctr == 4'd7) begin
                rdy <= 1'b1;
                // Assign lower 16 bits of product as final output (with truncation)
                p <= product[15:0];
            end
        end
    end

endmodule