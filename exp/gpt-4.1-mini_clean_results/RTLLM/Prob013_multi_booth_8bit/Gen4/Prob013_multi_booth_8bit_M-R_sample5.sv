module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine states
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    reg signed [15:0] multiplicand;        // sign-extended multiplicand (16 bits)
    reg [8:0] extended_multiplier;         // multiplier extended with one LSB zero (9 bits)
    reg signed [16:0] product;              // 17-bit accumulator
    reg [1:0] ctr;                         // 2-bit counter for 4 iterations (0 to 3)
    reg [1:0] state;

    reg [2:0] booth_bits;
    reg signed [2:0] digit;

    // Temporary variables declared at module scope
    reg signed [16:0] shifted_multiplicand;
    reg signed [16:0] add_value;

    // Function to decode radix-4 Booth digit from 3 bits
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Get Booth bits from extended multiplier at iteration ctr
    function [2:0] get_booth_bits;
        input [8:0] ext_mult;
        input [1:0] count;
        reg bit_high, bit_mid, bit_low;
        integer idx_high, idx_mid, idx_low;
        begin
            idx_high = 2*count + 1;
            idx_mid  = 2*count;
            idx_low  = 2*count - 1;
            bit_high = (idx_high <= 8) ? ext_mult[idx_high] : 1'b0;
            bit_mid  = (idx_mid  <= 8) ? ext_mult[idx_mid]  : 1'b0;
            bit_low  = (idx_low  >= 0) ? ext_mult[idx_low]  : 1'b0;
            get_booth_bits = {bit_high, bit_mid, bit_low};
        end
    endfunction

    // Sign-extend multiplicand to 17 bits
    function signed [16:0] sign_extend_17;
        input [15:0] val;
        begin
            sign_extend_17 = {val[15], val};
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            extended_multiplier <= {b, 1'b0}; // Append zero for Booth encoding
            product <= 17'sd0;
            ctr <= 2'd0;
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            case(state)
                IDLE: begin
                    // Start computation immediately on next clock
                    product <= 17'sd0;
                    ctr <= 2'd0;
                    rdy <= 1'b0;
                    state <= CALC;
                end

                CALC: begin
                    if (ctr < 2'd4) begin
                        // Get Booth bits for current iteration
                        booth_bits = get_booth_bits(extended_multiplier, ctr);
                        digit = booth_decode(booth_bits);

                        // Shift multiplicand left by 2*ctr bits (arithmetic shift)
                        shifted_multiplicand = sign_extend_17(multiplicand) <<< (2*ctr);

                        // Compute add_value = digit * shifted_multiplicand
                        case (digit)
                            3'sd2:  add_value = shifted_multiplicand <<< 1;    // 2 * multiplicand shifted
                            3'sd1:  add_value = shifted_multiplicand;
                            3'sd0:  add_value = 17'sd0;
                           -3'sd1:  add_value = -shifted_multiplicand;
                           -3'sd2:  add_value = -(shifted_multiplicand <<< 1);
                            default: add_value = 17'sd0;
                        endcase

                        // Accumulate partial product
                        product <= product + add_value;

                        ctr <= ctr + 1;
                    end else begin
                        // All iterations done, move to DONE
                        state <= DONE;
                        rdy <= 1'b1;
                        p <= product[15:0];
                    end
                end

                DONE: begin
                    // Wait here until reset; hold outputs stable
                    rdy <= 1'b1;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule