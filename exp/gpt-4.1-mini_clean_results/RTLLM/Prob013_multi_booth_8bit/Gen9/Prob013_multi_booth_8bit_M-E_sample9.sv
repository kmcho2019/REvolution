module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,     // multiplicand
    input      [7:0]   b,     // multiplier
    output reg [15:0]  p,     // product
    output reg         rdy     // ready signal
);

    // Internal signed registers
    reg signed [15:0] multiplicand;        // sign-extended multiplicand
    reg [8:0]         multiplier_ext;      // multiplier extended with an extra 0 LSB for Booth encoding

    reg signed [16:0] accumulator;         // 17-bit accumulator for partial sums
    reg [2:0]         cycle_cnt;            // cycle counter (0 to 4)
    reg               busy;

    // Booth encoding function: Input 3 bits, output control for partial product
    // 3 bits: {multiplier_ext[bit+1], multiplier_ext[bit], multiplier_ext[bit-1]}
    // Encoding to partial product:
    // 000 or 111 => 0
    // 001 or 010 => +multiplicand
    // 011 => +2*multiplicand
    // 100 => -2*multiplicand
    // 101 or 110 => -multiplicand
    // bit = 2*cycle number
    function signed [16:0] booth_pp;
        input [2:0] booth_bits;
        input signed [16:0] mcd; // multiplicand extended
        begin
            case (booth_bits)
                3'b000,
                3'b111: booth_pp = 17'sd0;
                3'b001,
                3'b010: booth_pp = mcd;
                3'b011: booth_pp = mcd <<< 1;  // *2
                3'b100: booth_pp = - (mcd <<< 1);
                3'b101,
                3'b110: booth_pp = -mcd;
                default: booth_pp = 17'sd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand
            multiplicand  <= {{8{a[7]}}, a};
            // Extend multiplier with one zero bit LSB for booth
            multiplier_ext <= {b, 1'b0};
            accumulator    <= 17'sd0;
            cycle_cnt      <= 3'd0;
            rdy            <= 1'b0;
            busy           <= 1'b1;
            p              <= 16'd0;
        end else if (busy) begin
            if (cycle_cnt < 3'd4) begin
                // For cycle i, examine bits 2i+1 down to 2i-1 of multiplier_ext (9 bits)
                // For i=0: bits [1: -1] but -1 out of range so treat as 0
                // We'll handle out-of-range bits as 0
                // Create booth_bits as {bit2i+1, bit2i, bit2i-1}
                // Taking care of boundaries:
                reg [2:0] booth_bits;
                integer bit_pos;
                bit_pos = 2*cycle_cnt;

                booth_bits[0] = (bit_pos == 0) ? 1'b0 : multiplier_ext[bit_pos - 1];
                booth_bits[1] = multiplier_ext[bit_pos];
                booth_bits[2] = (bit_pos + 1 <= 8) ? multiplier_ext[bit_pos + 1] : 1'b0;

                // Calculate partial product
                // Shift partial product left by 2*cycle_cnt (bit_pos)
                // multiplicand extended to 17 bits for shifting
                reg signed [16:0] mcd_ext;
                mcd_ext = {multiplicand[15], multiplicand}; // sign extend to 17 bits by repeating MSB

                reg signed [16:0] pp;
                pp = booth_pp(booth_bits, mcd_ext) <<< bit_pos;

                accumulator <= accumulator + pp;
                cycle_cnt <= cycle_cnt + 1;
                rdy <= 1'b0;
            end else begin
                // Done
                p <= accumulator[15:0];
                rdy <= 1'b1;
                busy <= 1'b0;
            end
        end
    end

endmodule