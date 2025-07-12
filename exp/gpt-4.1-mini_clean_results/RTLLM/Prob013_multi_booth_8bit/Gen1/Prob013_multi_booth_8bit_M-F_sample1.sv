module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,       // multiplicand
    input [7:0] b,       // multiplier
    output reg [15:0] p,
    output reg rdy
);

    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg [16:0] multiplier_ext;       // multiplier extended by 1 sign bit and 1 LSB zero bit: 8+1+1=10 bits
    reg [1:0] stage;                 // 2 bits to count 4 stages: 0 to 3
    reg signed [16:0] partial_sum;   // wider to hold partial sum with sign

    wire [2:0] booth_bits;
    reg signed [17:0] m_times;  // multiplicand times factor (-2 to 2) shifted by 2*stage

    // Extract the 3 bits for Booth encoding: bits [2*stage +1 : 2*stage -1]
    // Because multiplier_ext is 17 bits: indices 16 down to 0
    // For stage i: bits = multiplier_ext[2*i+1 : 2*i-1]
    // Since 2*i-1 can be -1 for i=0, assign 0 for negative indices (LSB padding)
    function [2:0] get_booth_bits;
        input [16:0] val;
        input integer i;
        reg b0,b1,b2;
        begin
            b0 = (2*i -1) >=0 ? val[2*i-1] : 1'b0;
            b1 = val[2*i];
            b2 = val[2*i+1];
            get_booth_bits = {b2,b1,b0};
        end
    endfunction

    // Decode Booth bits to multiplier factor: -2, -1, 0, 1, 2
    // Encoding mapping (standard radix-4 Booth recoding):
    // 000 = 0
    // 001 = +1
    // 010 = +1
    // 011 = +2
    // 100 = -2
    // 101 = -1
    // 110 = -1
    // 111 = 0
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000: booth_decode =  0;
                3'b001: booth_decode =  1;
                3'b010: booth_decode =  1;
                3'b011: booth_decode =  2;
                3'b100: booth_decode = -2;
                3'b101: booth_decode = -1;
                3'b110: booth_decode = -1;
                3'b111: booth_decode =  0;
                default: booth_decode = 0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= $signed({{8{a[7]}}, a}); // sign-extend a to 16 bits
            // Sign-extend b to 9 bits (8 bits plus sign bit), then add one zero LSB for Booth recoding (total 17 bits)
            // Actually, extend b 8 bits by sign, then append a zero at LSB:
            multiplier_ext <= { {8{b[7]}}, b, 1'b0}; 
            partial_sum <= 0;
            stage <= 0;
            p <= 0;
            rdy <= 0;
        end else begin
            if (!rdy) begin
                // Process one Booth digit per cycle
                // Extract booth bits
                // Use get_booth_bits function
                // Decode factor
                // Compute multiplicand * factor
                // Shift by 2*stage bits
                // Accumulate partial_sum
                reg signed [2:0] factor;
                reg signed [33:0] shifted_product; // to hold multiplicand*factor shifted by 2*stage

                factor = booth_decode(get_booth_bits(multiplier_ext, stage));

                // multiplicand * factor, factor in -2..2
                // multiplicand is 16-bit signed
                // We make a wider product (18 bits) to avoid overflow in shifts
                // Then shift by 2*stage bits to place the partial product correctly

                // Multiply multiplicand by factor
                m_times = multiplicand * factor;

                // Shift left by 2*stage bits (up to 6 bits for stage 3)
                // m_times is 18-bit signed (multiplicand is 16-bit signed, factor max 2)
                // After shift, max width = 18 + 6 = 24 bits safe
                shifted_product = $signed(m_times) <<< (2*stage);

                // Accumulate into partial_sum ( widen partial_sum for safe addition )
                // partial_sum is 17 bits; widen to 34 bits to add safely
                partial_sum <= $signed(partial_sum) + $signed(shifted_product[16:0]); 
                // The [16:0] truncated bits correspond to target product width; this is safe because product p is 16-bit.

                // Increment stage
                stage <= stage + 1;

                if (stage == 3) begin
                    // Done after this cycle (stage 3 is last)
                    p <= partial_sum[15:0]; // Assign lower 16 bits as product
                    rdy <= 1;
                end else begin
                    rdy <= 0;
                end
            end
        end
    end

endmodule