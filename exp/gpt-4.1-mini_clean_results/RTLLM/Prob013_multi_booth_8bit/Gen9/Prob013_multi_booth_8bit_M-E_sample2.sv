module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplicand
    input      [7:0]  b,       // multiplier
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // Internal registers
    reg signed [16:0] product;       // 17-bit register holds accumulator + multiplier + extra bit (for Booth recoding)
    reg signed [16:0] multiplicand;  // 17-bit sign-extended multiplicand
    reg [3:0] ctr;                   // 4-bit counter (0..8, 9 iterations)
    
    reg signed [16:0] partial;       // Partial multiple added per cycle

    // Booth decoding combinational block
    wire [2:0] booth_bits = product[2:0];

    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial = 17'sd0;                     // 0 * M
            3'b001, 3'b010: partial = multiplicand;               // +1 * M
            3'b011:         partial = multiplicand <<< 1;         // +2 * M
            3'b100:         partial = - (multiplicand <<< 1);     // -2 * M
            3'b101, 3'b110: partial = - multiplicand;             // -1 * M
            default:        partial = 17'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, load multiplicand and multiplier
            // multiplicand sign-extended to 17 bits
            multiplicand <= { {9{a[7]}}, a };
            // product = {sign-extend multiplier 8 bits, multiplier 8 bits, 1 bit zero}
            // Sign extend multiplier 8 bits to upper bits (8 bits sign extension), then multiplier bits, then 1 zero bit
            product <= { {8{b[7]}}, b, 1'b0 };
            ctr <= 4'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 4'd9) begin
                // Add partial multiple aligned with upper bits product[16:1]
                // product[16:1] += partial
                product[16:1] <= product[16:1] + partial[16:1];

                // Arithmetic right shift product by 2 bits preparing for next step
                product <= $signed(product) >>> 2;

                // Increment iteration counter
                ctr <= ctr + 1;
            end else begin
                // Multiplication done
                p <= product[16:1];  // final 16-bit product
                rdy <= 1'b1;
            end
        end
    end

endmodule