module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,  // multiplicand
    input [7:0] b,  // multiplier
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] multiplicand; // sign-extended a
    reg [15:0] multiplier;   // sign-extended b, with an extra bit appended for Booth encoding
    reg [3:0] step;          // 4 steps needed for 8-bit radix-4 (2 bits per step)
    
    // Booth encoded value from 3 bits of multiplier
    reg [2:0] booth_bits;
    reg signed [17:0] multiplicand_ext; // extended multiplicand for multiplication by ±2
    reg signed [17:0] pp;                // partial product
    
    // Temporary accumulator for partial product addition
    reg signed [17:0] acc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a}; // sign-extend multiplicand
            // Append a zero LSB to multiplier for Booth encoding (one extra bit)
            multiplier <= {{8{b[7]}}, b, 1'b0};
            p <= 16'd0;
            step <= 0;
            rdy <= 0;
            acc <= 18'd0;
        end else if (!rdy) begin
            if (step < 4) begin
                // Extract 3 bits for Booth encoding: bits [2*step+1 : 2*step-1]
                booth_bits = multiplier[2*step +: 3]; // slice 3 bits starting at 2*step
                // Sign extend multiplicand for operations *2 or -2
                multiplicand_ext = {multiplicand[15], multiplicand, 1'b0}; // left shift by 1 (multiply by 2), width 18 bits
                
                // Decode booth_bits to partial product:
                // Encoding:
                // 000 -> 0
                // 001 -> +1 * multiplicand
                // 010 -> +1 * multiplicand
                // 011 -> +2 * multiplicand
                // 100 -> -2 * multiplicand
                // 101 -> -1 * multiplicand
                // 110 -> -1 * multiplicand
                // 111 -> 0
                case (booth_bits)
                    3'b000, 3'b111: pp = 18'sd0;
                    3'b001, 3'b010: pp = { {2{multiplicand[15]}}, multiplicand};       // +1 × multiplicand
                    3'b011:         pp = multiplicand_ext;                            // +2 × multiplicand
                    3'b100:         pp = -multiplicand_ext;                           // -2 × multiplicand
                    3'b101, 3'b110: pp = -{ {2{multiplicand[15]}}, multiplicand};     // -1 × multiplicand
                    default:        pp = 18'sd0; // default to zero for safety
                endcase

                // Shift partial product left by 2*step bits to align (already accounted in multiplier slicing)
                // Actually no extra shift needed as we align by choosing the bits in multiplier

                // Accumulate partial product into acc
                acc <= acc + (pp <<< (2*step));

                // Update output p with lower 16 bits of accumulator
                p <= acc[15:0];

                // Next step
                step <= step + 1;
            end else begin
                // Multiplication finished
                rdy <= 1;
            end
        end
    end

endmodule