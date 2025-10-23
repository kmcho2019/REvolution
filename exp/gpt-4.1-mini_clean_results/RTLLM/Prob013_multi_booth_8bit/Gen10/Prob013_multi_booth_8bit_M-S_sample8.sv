module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input
    input      [7:0]  b,        // multiplier input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // Registers for radix-4 Booth
    reg signed [16:0] product;           // 17 bits for sign + extra bit
    reg signed [15:0] multiplicand;      // sign-extended multiplicand
    reg signed [9:0]  multiplier_ext;    // multiplier + appended bit (9 bits)
    reg [2:0]         count;              // 0 to 4 (4 cycles for 8-bit radix-4)

    // Booth encoding: based on 3 bits: {multiplier_ext[1:0], prev_bit}
    // multiplier_ext[0] is LSB, prev_bit is appended bit multiplier_ext[ -1 ] (lowest bit 0 initially)

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= { {8{a[7]}}, a };            // sign-extend multiplicand
            // Append one zero bit to multiplier LSB for booth encoding
            multiplier_ext <= { b, 1'b0 };                // 9 bits: 8 bits b + 1 appended 0 LSB
            product <= 17'sd0;
            count <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            // Booth recoding: select operation based on lowest 3 bits: multiplier_ext[2:0]
            // bits: q0 = multiplier_ext[0], q1 = multiplier_ext[1], q_1 = multiplier_ext[-1] (lowest appended bit)
            // In multiplier_ext, the appended bit is bit 0, next bits 1,2,...
            // But we have multiplier_ext[2:0] for booth recoding: bits 2,1,0 (where 0 is appended bit)
            // Actually, radix-4 uses three bits: q2 q1 q0; here q0 = appended bit, q1 = multiplier_ext[0], q2=multiplier_ext[1]
            // We'll take multiplier_ext[2:0] for this.

            case (multiplier_ext[2:0])
                3'b000, 3'b111: ; // 0 * multiplicand, no add
                3'b001, 3'b010: product <= product + multiplicand;      // +1 * multiplicand
                3'b101, 3'b110: product <= product - multiplicand;      // -1 * multiplicand
                3'b011: product <= product + (multiplicand <<< 1);      // +2 * multiplicand
                3'b100: product <= product - (multiplicand <<< 1);      // -2 * multiplicand
                default: ; // do nothing for safety
            endcase

            // Arithmetic right shift multiplier_ext by 2 bits for next cycle
            // Keep sign for high bits: we use signed type to preserve sign bits on shift
            multiplier_ext <= $signed(multiplier_ext) >>> 2;

            count <= count + 1'b1;

            if (count == 3'd3) begin
                // Done 4 cycles (processing 8 bits two bits per cycle)
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end else begin
            // Keep output stable when ready
            rdy <= 1'b1;
            p <= p;
        end
    end

endmodule