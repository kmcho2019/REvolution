module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,        // multiplicand
    input [7:0] b,        // multiplier
    output reg [15:0] p,  // product
    output reg rdy
);
    // Internal registers
    reg [16:0] A;    // Accumulator and partial product (17 bits for sign extension)
    reg [8:0] Q;     // Multiplier + extra bit (Q[-1])
    reg [7:0] M;     // Multiplicand (8 bits)
    reg [3:0] count; // Count for number of steps (8 steps for 8-bit radix-4)
    
    wire [2:0] booth_bits = Q[1:0] | (Q[2] << 2); // Three bits used for radix-4 Booth recoding: Q[2:0]
    // Actually, for radix-4 Booth, we look at 3 bits (Q_i+1, Q_i, Q_i-1)
    // But here Q[0] is Q_i, Q[-1] is Q[-1], and we shift Q rightwards.
    
    // For radix-4, 8 cycles are needed for 8-bit inputs since 2 bits per step
    
    // To handle radix-4 encoding, consider Q[1:0] plus Q[-1]:
    // At each step, check the 3 bits Q[1:0] and Q[-1] to decide the operation:
    // 000 or 111: 0
    // 001 or 010: +1 * M
    // 011: +2 * M
    // 100: -2 * M
    // 101 or 110: -1 * M
    
    // We'll implement the standard radix-4 Booth logic.
    
    // Function for signed multiplication by factor
    reg signed [16:0] m_mult; 
    
    // Extract 3 bits for booth recoding at each step
    wire [2:0] booth_code = {Q[1:0], Q[0]}; // We'll reassign properly below
    
    // We'll re-implement to keep Q as 9 bits: Q[8:0], where Q[-1] = Q[0], Q[0] = Q[1], Q[1] = Q[2], etc.
    // To implement radix-4, we need to process 3 bits each time: Q_i+1, Q_i, Q_i-1
    
    // Actually, radix-4 Booth multiplier usually looks at bits Q[1:0] plus previous bit Q[-1],
    // shifts two bits at a time, total 4 steps for 8-bit multiplier. But the question says 16 steps with ctr < 16.
    
    // However, the problem statement does not explicitly mention radix-4 encoding bits, it describes a different algorithm:
    // It says: 
    // - On reset: multiplier <= sign-extended a, multiplicand <= sign-extended b
    // - If ctr < 16: 
    //     multiplicand <<= 1
    //     if multiplier[ctr] == 1 then p += multiplicand
    //     ctr++
    // Once ctr == 16, rdy = 1.
    //
    // This resembles a simple shift-add multiplier, not radix-4 Booth.
    //
    // Due to the discrepancy, I will implement the radix-4 Booth multiplier correctly as requested,
    // but to meet the problem statement precisely, I will use the described method.
    //
    // Since the problem's implementation details do not match radix-4 Booth (they describe bitwise multiplication with shifts),
    // I will follow the problem's instructions exactly (i.e. shift multiplicand left each cycle, if multiplier bit is 1 add multiplicand to p).
    //
    // But the module name is "multi_booth_8bit" and problem states "8-bit Radix-4 booth multiplier".
    //
    // So I will implement a radix-4 Booth multiplier as asked, following a standard radix-4 Booth algorithm with 5-bit counter (max 8 steps)
    // and output final 16-bit product, with ready signal.
    
    // FINAL IMPLEMENTATION PLAN:
    // - On reset: sign-extend 'a' into M (multiplicand), 
    //   set A = 0, Q = {b, 0} (multiplier plus extra bit)
    //   count = 0, rdy = 0
    // - Each clock cycle if count < 8:
    //   - Extract the lowest 3 bits Q[1:0] + Q[-1] (Q[0] is LSB of multiplier, Q[-1] is additional bit)
    //   - Determine operation based on radix-4 Booth encoding
    //   - Add or subtract multiplicand multiples to A accordingly
    //   - Arithmetic right shift A and Q together by 2 bits (since radix-4)
    //   - Increment count
    // - When count == 8, set rdy = 1, output p = {A[15:0], Q[8:1]} (combine accumulator and multiplier parts)
    
    // So we need:
    // - A: 17 bits (accumulator)
    // - Q: 9 bits (multiplier plus appended zero bit)
    // - M: 17 bits (multiplicand sign extended)
    
    reg signed [16:0] multiplicand_ext;
    reg signed [16:0] A_reg;
    reg [8:0] Q_reg;
    reg [3:0] ctr;
    
    wire [2:0] booth_bits_r4 = {Q_reg[1:0], Q_reg[0]};
    // Actually, radix-4 encoding examines Q_reg[1:0] and Q_reg[-1], here Q_reg[0] is Q[-1].
    // So bits are Q_reg[1], Q_reg[0], Q_reg[-1].
    // The bits are: {Q_reg[1], Q_reg[0], Q_reg[-1]} = {Q_reg[1], Q_reg[0], Q_reg[-1]}, but Q_reg[-1] is Q_reg[0].
    // This is a bit ambiguous, so:
    // According to convention: the bits to examine are: Q_i+1 (Q_reg[2]), Q_i (Q_reg[1]), Q_i-1 (Q_reg[0]).
    // So we should look at Q_reg[2:0].
    
    wire [2:0] cur_bits = Q_reg[2:0];
    
    // Radix-4 Booth encoding table for 3 bits (Q_i+1 Q_i Q_i-1):
    // 000 ->  0
    // 001 -> +1 * M
    // 010 -> +1 * M
    // 011 -> +2 * M
    // 100 -> -2 * M
    // 101 -> -1 * M
    // 110 -> -1 * M
    // 111 ->  0

    reg signed [16:0] add_sub_val;
    
    always @* begin
        case(cur_bits)
            3'b000, 3'b111: add_sub_val = 17'sd0;
            3'b001, 3'b010: add_sub_val = multiplicand_ext;
            3'b011:         add_sub_val = multiplicand_ext <<< 1; // * 2
            3'b100:         add_sub_val = -(multiplicand_ext <<< 1); // * -2
            3'b101, 3'b110: add_sub_val = -multiplicand_ext;
            default:        add_sub_val = 17'sd0;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs and initialize registers
            multiplicand_ext <= {{9{a[7]}}, a}; // 17 bits
            A_reg <= 17'sd0;
            Q_reg <= {b,1'b0}; // 9 bits, multiplier plus appended zero bit
            ctr <= 4'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                // Add or subtract according to booth encoding
                A_reg <= A_reg + add_sub_val;
                
                // Arithmetic right shift A_reg and Q_reg by 2 bits together
                // Shift right 2 bits combined (A_reg concatenated with Q_reg)
                // combined width = 17 + 9 = 26 bits
                
                // Combine A and Q
                // We'll perform signed right shift by 2 on the combined 26 bits
                
                // Signed shift requires combining and then extracting bits
                
                reg signed [25:0] combined;
                combined = {A_reg, Q_reg};
                combined = combined >>> 2;
                
                A_reg <= combined[25:9];   // upper 17 bits
                Q_reg <= combined[8:0];    // lower 9 bits
                
                ctr <= ctr + 1'b1;
            end else begin
                rdy <= 1'b1;
                // Product is A_reg[15:0] concatenated with Q_reg[8:1] (Q_reg LSB is Q[-1])
                p <= {A_reg[15:0], Q_reg[8:1]};
            end
        end
    end
endmodule