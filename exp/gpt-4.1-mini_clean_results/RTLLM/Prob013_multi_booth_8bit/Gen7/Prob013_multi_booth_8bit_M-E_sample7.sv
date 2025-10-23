module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,       // multiplicand
    input wire [7:0] b,       // multiplier
    output reg [15:0] p,      // product output
    output reg rdy            // ready signal
);

    // State encoding
    typedef enum reg [1:0] {IDLE=2'b00, BUSY=2'b01, DONE=2'b10} state_t;
    reg [1:0] state;

    reg signed [15:0] multiplicand; // sign-extended multiplicand (16 bits)
    reg signed [16:0] acc;          // accumulator 17 bits (extra bit for sign)
    reg [8:0] multiplier;           // multiplier + appended zero bit (9 bits)

    reg [2:0] cycle_cnt;            // counts up to 4 (for 4 radix-4 cycles)

    reg signed [16:0] partial_prod; // partial product per cycle

    // Booth encoding function (3 bits) for Radix-4 Booth recoding
    // Input: 3 bits formed by multiplier[1:0] and multiplier[0-1]
    // Output: multiplier for multiplicand: -2, -1, 0, 1, 2
    function signed [2:0] booth_decode(input [2:0] bits);
        case (bits)
            3'b000, 3'b111: booth_decode = 3'd0;
            3'b001, 3'b010: booth_decode = 3'd1;
            3'b011:         booth_decode = 3'd2;
            3'b100:         booth_decode = -3'd2;
            3'b101, 3'b110: booth_decode = -3'd1;
            default:        booth_decode = 3'd0;
        endcase
    endfunction

    // Arithmetic right shift by 2 of combined acc and multiplier registers
    // combined is acc(17 bits) concatenated with multiplier(9 bits) = 26 bits
    // After shift, acc takes upper 17 bits, multiplier takes lower 9 bits
    task arithmetic_shift_right_2;
        input [25:0] in_val;
        output [16:0] out_acc;
        output [8:0] out_multiplier;
        reg signed [25:0] signed_val;
    begin
        // Extend sign for arithmetic shift
        signed_val = {in_val[25], in_val}; // extend sign bit
        signed_val = signed_val >>> 2;
        out_acc = signed_val[24:8];       // upper 17 bits
        out_multiplier = signed_val[7:0]; // lower 8 bits
    end
    endtask

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= { {8{a[7]}}, a };      // sign-extend multiplicand to 16 bits
            acc <= 17'd0;
            multiplier <= {b, 1'b0};                 // multiplier extended with appended zero bit
            cycle_cnt <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
            state <= BUSY;
        end else begin
            case (state)
                IDLE: begin
                    // Wait here until reset (or design can be expanded for load enable)
                    rdy <= 1'b0;
                    p <= 16'd0;
                end

                BUSY: begin
                    // Extract the 3 bits for booth decoding:
                    // multiplier[1:0] + multiplier[0-1] (bit below 0 is replaced by zero appended bit)
                    // Here multiplier[1:0] is LSB and second LSB, multiplier[0] is appended zero bit at LSB
                    // To form 3-bit booth bits: multiplier[1:0] + appended bit multiplier[-1] = multiplier[1:0] + multiplier[0]
                    // The 3 bits are multiplier[1], multiplier[0], multiplier[-1], but appended bit is multiplier[0]
                    // So the three bits are multiplier[1:0] plus appended bit multiplier[0] again (we can pick multiplier[1:0] + appended zero bit)
                    // Because appended zero bit is multiplier[0], multiplier bits are [8:0], multiplier[0] is appended zero
                    // So booth_bits = multiplier[1:0] + multiplier[0] == multiplier[1:0] and multiplier[0]
                    // To simplify: booth_bits = {multiplier[1], multiplier[0], multiplier[-1]} == multiplier[1:0] plus appended zero bit (multiplier[0])
                    // Since multiplier[0] is appended bit, 3 bits are multiplier[1:0] + multiplier[-1] = multiplier[0]
                    // Actually just multiplier[2:0], as multiplier[0] is appended zero bit, so multiplier[2:0] exist
                    // But multiplier is 9 bits, so multiplier[2:0] is valid.
                    // We'll pick multiplier[2:0]
                    // So booth_bits = multiplier[2:0]

                    // Decode booth code
                    // Compute partial product: multiplicand * booth_decode
                    // partial product is signed 17 bits (sign-extend multiplicand to 17 bits)
                    reg signed [16:0] multiplicand_ext;
                    reg signed [2:0] booth_val;
                    multiplicand_ext = {multiplicand[15], multiplicand};
                    booth_val = booth_decode(multiplier[2:0]);

                    case (booth_val)
                        3'd0:   partial_prod = 17'd0;
                        3'd1:   partial_prod = multiplicand_ext;
                        3'd2:   partial_prod = multiplicand_ext <<< 1; // *2
                        -3'd1:  partial_prod = -multiplicand_ext;
                        -3'd2:  partial_prod = -(multiplicand_ext <<< 1);
                        default:partial_prod = 17'd0;
                    endcase

                    // Add partial product to accumulator
                    acc <= acc + partial_prod;

                    // Arithmetic right shift acc and multiplier registers by 2 bits
                    // Combine acc and multiplier as 26-bit vector
                    reg [25:0] combined;
                    combined = {acc + partial_prod, multiplier};
                    reg signed [25:0] combined_signed;
                    combined_signed = combined;

                    combined_signed = combined_signed >>> 2; // arithmetic shift right by 2

                    acc <= combined_signed[24:8];        // upper 17 bits
                    multiplier <= combined_signed[7:0];  // lower 8 bits, append zero bit is lost, so maintain 9 bits by shifting in sign extension

                    // We must maintain 9 bits in multiplier with appended zero bit at LSB
                    // The shift reduced combined by 2 bits, so multiplier becomes bits [7:0], only 8 bits
                    // To keep appended zero bit, shift multiplier left by 1 and append 0:
                    // But this contradicts with arithmetic shift logic.
                    // So instead, implement arithmetic shift for acc and multiplier registers separately.

                    // Let's rewrite shift differently:

                    // Separate arithmetic shift right by 2 bits for acc and multiplier registers:
                    // We'll create a 26-bit signed value {acc, multiplier}, then arithmetic shift right by 2.
                    // After shift:
                    // acc = combined[24:8]
                    // multiplier = combined[7:0] appended with 1 zero bit at LSB to keep 9 bits?

                    // For simplicity, take multiplier after shift as combined_signed[7:0] plus one zero at LSB.

                    // Correct approach:
                    // After shift, multiplier = combined_signed[8:0], acc = combined_signed[25:9]

                    acc <= combined_signed[25:9];
                    multiplier <= combined_signed[8:0];

                    // Increment cycle count
                    cycle_cnt <= cycle_cnt + 1;

                    if (cycle_cnt == 3) begin
                        // Last cycle done
                        p <= {acc[15:0]}; // lower 16 bits of accumulator is product
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold ready until reset
                    rdy <= 1'b1;
                    // Optional: wait for new reset or enable for new multiplication
                end

            endcase
        end
    end

endmodule