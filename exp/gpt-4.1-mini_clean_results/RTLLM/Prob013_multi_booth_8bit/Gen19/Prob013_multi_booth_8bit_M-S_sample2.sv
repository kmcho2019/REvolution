module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    reg signed [15:0] multiplicand;   // sign-extended multiplicand (16 bits)
    reg signed [17:0] multiplier;     // multiplier + 1 bit extension (for Booth)
    reg [3:0] ctr;                    // iteration counter (0 to 4)
    reg signed [31:0] product;        // accumulator for result (32 bits to avoid overflow)

    // Extract 3 bits for Booth recoding: multiplier[1: -1], negative bit is considered zero
    wire [2:0] booth_bits = multiplier[1: -1 + 1];

    // Because Verilog doesn't support negative index, define booth_bits differently:
    // We'll extract bits multiplier[1:0] plus a LSB zero bit (multiplier[-1]=0)
    wire [2:0] booth_code;
    assign booth_code = {multiplier[1:0], 1'b0};

    // Actually to handle negative bit correctly, we can use:
    // booth_bits = {multiplier[1], multiplier[0], multiplier[-1]}
    // but Verilog doesn't allow negative indexing, so we extend multiplier with an extra 0 bit at LSB when loading.
    // So here multiplier is 18 bits, we use bits [1: -1] = bits[1:0] + extra LSB zero bit (bit -1 = 0).
    // We'll redefine multiplier: multiplier = {b, 1'b0}, so bit0 = b[0], bit-1=0.
    // So booth_code = {multiplier[1], multiplier[0], multiplier[-1]} = {multiplier[1], multiplier[0], 0}

    // For code clarity, define booth_code properly in sequential block below.

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // sign extend multiplicand and multiplier
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{b}, 1'b0}; // multiplier extended by one LSB zero for Booth
            product      <= 0;
            ctr          <= 0;
            rdy          <= 0;
            p            <= 0;
        end else if (!rdy) begin
            // Extract booth_code = {multiplier[1], multiplier[0], multiplier[-1]} 
            // where multiplier[-1] = 0 (we added a zero bit at LSB)
            reg [2:0] code;
            code[2] = multiplier[1];
            code[1] = multiplier[0];
            code[0] = 1'b0;  // LSB zero bit

            // Compute partial product based on Booth radix-4 rules
            reg signed [31:0] pp;
            case (code)
                3'b000, 3'b111: pp = 0;
                3'b001, 3'b010: pp = multiplicand;        // +1 * multiplicand
                3'b011:         pp = multiplicand <<< 1; // +2 * multiplicand
                3'b100:         pp = -(multiplicand <<< 1); // -2 * multiplicand
                3'b101, 3'b110: pp = -multiplicand;       // -1 * multiplicand
                default:        pp = 0;
            endcase

            // Add partial product shifted by 2*ctr bits to product
            product <= product + (pp <<< (2*ctr));

            // Arithmetic shift right multiplier by 2 bits for next booth digit
            // Sign extend by replicating bit 17
            multiplier <= { {2{multiplier[17]}}, multiplier[17:2] };

            ctr <= ctr + 1;

            // When 4 iterations done (8 bits / 2 bits per step)
            if (ctr == 4) begin
                rdy <= 1;
                p <= product[15:0]; // truncate product to 16 bits (lower bits)
            end
        end
    end

endmodule