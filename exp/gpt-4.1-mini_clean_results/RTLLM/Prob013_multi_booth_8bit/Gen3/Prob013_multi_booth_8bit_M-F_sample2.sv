module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,    // multiplicand
    input wire [7:0] b,    // multiplier
    output reg [15:0] p,
    output reg rdy
);

    // Sign-extended multiplicand to 16 bits signed
    reg signed [15:0] multiplicand;

    // Multiplier extended by 1 LSB bit for Booth encoding (9 bits total)
    reg [8:0] booth_reg;

    // 3-bit counter for 4 cycles (0 to 3)
    reg [2:0] count;

    // Accumulator with enough bits to hold intermediate sums (18 bits signed)
    reg signed [17:0] acc;

    // Wires to hold the 3 bits for current booth group and partial product
    wire [2:0] booth_bits;
    wire signed [17:0] pp; // partial product after Booth decoding

    // Generate bit_minus_1, which is zero for the first group (when 2*count == 0)
    wire bit_minus_1 = (2*count == 0) ? 1'b0 : booth_reg[2*count - 1];

    // Extract booth_bits from booth_reg, indices [2*count+1 : 2*count] plus bit_minus_1
    assign booth_bits = { booth_reg[2*count + 1], booth_reg[2*count], bit_minus_1 };

    // Booth decoding function
    function signed [17:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] m;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 18'sd0;
                3'b001, 3'b010: booth_decode = { {2{m[15]}}, m };           // +1 * multiplicand
                3'b011:         booth_decode = { {1{m[15]}}, m, 1'b0 };     // +2 * multiplicand (shift left 1)
                3'b100:         booth_decode = -({ {1{m[15]}}, m, 1'b0 });   // -2 * multiplicand
                3'b101, 3'b110: booth_decode = -({ {2{m[15]}}, m });         // -1 * multiplicand
                default:        booth_decode = 18'sd0;                       // safe default
            endcase
        end
    endfunction

    assign pp = booth_decode(booth_bits, multiplicand);

    // Enable signal to gate accumulation only when multiplication is in progress
    wire run = !rdy;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Proper sign-extension of multiplicand (a) to 16 bits
            multiplicand <= { {8{a[7]}}, a };
            // Extend multiplier b to 9 bits by appending 1 LSB zero bit for Booth encoding
            booth_reg <= { b, 1'b0 };
            acc <= 18'sd0;
            count <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (run) begin
            if (count < 4) begin
                // Accumulate partial product shifted by 2*count bits
                acc <= acc + (pp <<< (2*count));
                count <= count + 1'b1;
            end else begin
                // Multiplication done
                p <= acc[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule