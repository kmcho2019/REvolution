module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready signal
);

    // Extended inputs/sign-extended
    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg [9:0]         booth_mul;     // multiplier with 2 zero bits appended (10 bits)
    
    // Internal product accumulator (signed)
    reg signed [31:0] product_accum;

    // Cycle counter: counts 0 to 3 (4 cycles for radix-4 8-bit multiplier)
    reg [2:0] cycle_count;

    // Decode the 3-bit booth code to multiplier factor [-2..2]
    // bits: {bit2, bit1, bit0} = {next_bit, current_bit, previous_bit}
    // Encoding follows standard radix-4 Booth decoding rules
    function signed [2:0] booth_decode;
        input [2:0] code;
        begin
            case(code)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Extract booth code for the current cycle (3 bits)
    // The 3 bits start at bit position (2*cycle_count) of booth_mul, with one bit before and after as needed
    reg [2:0] booth_code;

    // Signals for partial product
    reg signed [31:0] partial_product;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            multiplicand  <= { {8{a[7]}}, a };          // sign-extend multiplicand
            booth_mul     <= {b, 2'b00};                 // append two zeros for safe booth encoding
            product_accum <= 32'sd0;
            cycle_count   <= 3'd0;
            p             <= 16'd0;
            rdy           <= 1'b0;
        end else begin
            if (!rdy) begin
                if (cycle_count < 3'd4) begin
                    // Extract the 3-bit booth code for this cycle from booth_mul
                    // Need bits: bit at position 2*cycle_count + 1 down to 2*cycle_count -1
                    // Because booth_mul is 10 bits [9:0], and lower bits are LSB
                    // Handle boundary for bit -1: treat as zero if out-of-range

                    integer bit_pos;
                    reg bit_minus1, bit0, bit1;

                    bit_pos = cycle_count*2;

                    bit_minus1 = (bit_pos == 0) ? 1'b0 : booth_mul[bit_pos - 1];
                    bit0       = booth_mul[bit_pos];
                    bit1       = (bit_pos + 1 < 10) ? booth_mul[bit_pos + 1] : 1'b0;

                    booth_code = {bit1, bit0, bit_minus1};

                    // Decode booth code to factor
                    // Multiply multiplicand by factor (-2..2)
                    partial_product = 0;
                    case (booth_decode(booth_code))
                        3'sd0: partial_product = 32'sd0;
                        3'sd1: partial_product = {{16{multiplicand[15]}}, multiplicand}; // sign extend multiplicand to 32 bits
                        3'sd2: partial_product = ({{16{multiplicand[15]}}, multiplicand}) <<< 1;
                        -3'sd1: partial_product = - ({{16{multiplicand[15]}}, multiplicand});
                        -3'sd2: partial_product = - (({{16{multiplicand[15]}}, multiplicand}) <<< 1);
                        default: partial_product = 32'sd0;
                    endcase

                    // Shift partial product by 2*cycle_count bits to align position
                    partial_product = partial_product <<< (2*cycle_count);

                    // Accumulate
                    product_accum <= product_accum + partial_product;

                    // Increment cycle count
                    cycle_count <= cycle_count + 1'b1;
                end else begin
                    // After all cycles completed, output final product and set ready
                    p   <= product_accum[15:0]; // Lower 16 bits (the product)
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule