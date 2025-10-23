module multi_booth_8bit (
    input               clk,
    input               reset,
    input       [7:0]   a,      // multiplicand input
    input       [7:0]   b,      // multiplier input
    output reg  [15:0]  p,      // product output
    output reg          rdy      // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;        // multiplicand sign-extended 16 bits
    reg signed [16:0] product;             // product register 17 bits to handle shifts and sign
    reg [16:0] multiplier;                 // multiplier plus appended zero bit for Booth encoding

    reg [3:0] ctr;                        // 4-bit counter for 8 iterations (0 to 7)
    reg busy;

    // Helper function: Radix-4 Booth encoding to multiplicand multiples
    // The 3 bits input is in form {multiplier[1:0], prev_bit}
    // Output is signed multiple: 0, +1M, +2M, -1M, or -2M
    // Encoding:
    // 000 => 0
    // 001 => +1
    // 010 => +1
    // 011 => +2
    // 100 => -2
    // 101 => -1
    // 110 => -1
    // 111 => 0
    function signed [17:0] booth_multiples; // 18-bit for overflow handling
        input [2:0] bits;
        input signed [15:0] M;
        reg signed [17:0] mul;
    begin
        case(bits)
            3'b000, 3'b111: mul = 18'sd0;
            3'b001, 3'b010: mul = { {2{M[15]}}, M };        // +1 * M (16-bit to 18-bit sign extended)
            3'b011:         mul = ({ {1{M[15]}}, M }) <<< 1; // +2 * M
            3'b100:         mul = -(({ {1{M[15]}}, M }) <<< 1); // -2 * M
            3'b101, 3'b110: mul = -({ {2{M[15]}}, M });       // -1 * M
            default:        mul = 18'sd0;
        endcase
        booth_multiples = mul;
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Load inputs: multiplicand = a, multiplier = b, product=0, counter=0
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand
            multiplier   <= {b, 1'b0};       // multiplier with appended 0 at LSB (for Booth encoding)
            product      <= 17'sd0;
            ctr          <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            busy         <= 1'b1;
        end else if (busy) begin
            // Perform one Radix-4 Booth iteration per clock cycle

            // Extract the current 3 bits for Booth encoding: bits [1:0] and prev bit [2] (LSB side)
            // Using multiplier[1:0] plus multiplier[2] as prev bit
            // multiplier is 17 bits wide: bits 16 down to 0
            // The LSB is multiplier[0]
            // For current iteration, we look at multiplier[1:0] and multiplier[2]
            // But multiplier[2] may not exist if ctr is at last iteration => but we have 17 bits to cover all cycles safely
            // We always use bits: multiplier[1:0] and multiplier[2], which move down each cycle because multiplier shifts right 2 bits each cycle.

            // Get bits for booth encoding
            wire [2:0] booth_bits = multiplier[1:0] | (multiplier[2] << 2);
            // But the above is a bit of a mistake - must concatenate bits
            // Corrected: {multiplier[2], multiplier[1], multiplier[0]}
            // Actually, the usual radix-4 booth encoding uses bits [i+1, i, i-1]
            // Since we have appended zero at LSB as multiplier[-1], bits are multiplier[1:0] plus prev bit multiplier[-1]
            // But our 'multiplier' has appended 0 at LSB at bit 0, so prev bit = multiplier[0], bits for current iteration are multiplier[2], multiplier[1], multiplier[0]
            // So we must get bits [2:0] from multiplier[2:0]
            // Since multiplier is shifted right 2 bits each cycle, the relevant bits will be at LSB.
            // Let's just extract multiplier[2:0] for booth encoding.

            // To implement this cleanly, move this logic outside always block as a combinational assignment.

        end
    end

    // Because we need combinational logic to get booth bits and multiples each cycle, let's split logic properly.

    // Updated code with combinational logic for booth encoding and sequential registers.
    // This entire process cannot be done in a single always block without combinational logic. We'll split them.

endmodule