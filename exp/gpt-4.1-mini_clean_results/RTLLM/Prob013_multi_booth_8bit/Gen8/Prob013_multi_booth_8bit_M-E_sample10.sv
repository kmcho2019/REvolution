module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,    // multiplicand
    input      [7:0]   b,    // multiplier
    output reg [15:0]  p,    // product output
    output reg         rdy    // ready signal
);

    // Internal registers
    reg [8:0] multiplicand_ext;    // 9-bit sign extended multiplicand (a), for -2x multiple calculations
    reg [8:0] multiplicand_neg;    // negative multiplicand_ext (2's complement)
    reg [8:0] multiplicand_2x;     // multiplicand_ext shifted left by 1 (times 2)
    reg [8:0] multiplicand_neg2x;  // negative of multiplicand_2x

    reg [8:0] multiplier_ext;      // multiplier extended with one LSB zero (for 3-bit encoding slices)

    reg [3:0] iter; // iteration counter (0 to 3, total 4 iterations)

    // Partial product as signed 16-bit
    reg signed [15:0] partial_prod;

    // Signed version of inputs for sign extension
    wire signed [8:0] a_se = {a[7], a}; // sign-extended multiplicand (9-bit)
    wire [8:0] b_se;

    // Build multiplier_ext by concatenating multiplier and 1 LSB zero for radix-4 booth
    // b_se is 9 bits: {b[7], b} plus one LSB zero
    // We'll do this in reset block

    // Booth encoding function: takes 3 bits and returns multiplier factor (-2..+2)
    function signed [2:0] booth_encode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000,
                3'b111: booth_encode = 3'sd0;    // 0
                3'b001,
                3'b010: booth_encode = 3'sd1;    // +1
                3'b011: booth_encode = 3'sd2;    // +2
                3'b100: booth_encode = -3'sd2;   // -2
                3'b101,
                3'b110: booth_encode = -3'sd1;   // -1
                default: booth_encode = 3'sd0;
            endcase
        end
    endfunction

    // Compute partial product multiple based on booth multiplier factor
    function signed [15:0] compute_partial;
        input signed [2:0] factor;
        input signed [8:0] multiplicand;
        begin
            case(factor)
                3'sd0:  compute_partial = 16'sd0;
                3'sd1:  compute_partial = {{7{multiplicand[8]}}, multiplicand};           // multiplicand extended to 16 bits signed
                3'sd2:  compute_partial = {{6{multiplicand[8]}}, multiplicand, 1'b0};   // multiplicand*2 (shift left 1)
                -3'sd1: compute_partial = -{{7{multiplicand[8]}}, multiplicand};
                -3'sd2: compute_partial = -{{6{multiplicand[8]}}, multiplicand, 1'b0};
                default:compute_partial = 16'sd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize extended inputs for signed operations
            multiplicand_ext <= {a[7], a};       // sign-extend multiplicand (9 bits)
            multiplier_ext   <= {b, 1'b0};       // multiplier extended with LSB zero for Booth encoding (9 bits)
            p               <= 16'sd0;
            iter            <= 4'd0;
            rdy             <= 1'b0;
        end else if (!rdy) begin
            // Extract 3 bits of multiplier for current iteration booth encoding: bits [2*i+1 : 2*i-1]
            // For iter i: bits are multiplier_ext[2*iter+1 : 2*iter-1]
            // Because multiplier_ext is 9 bits (index 8 down to 0),
            // we do a slice with care for iter=0..3
            // For example iter=0: bits[1: -1], but negative index is not valid.
            // So let's define the bits as:
            // bits = {multiplier_ext[2*iter+1], multiplier_ext[2*iter], multiplier_ext[2*iter-1]}
            // for iter=0, bits = {multiplier_ext[1], multiplier_ext[0], 0}
            // For negative index, substitute 0.

            reg [2:0] booth_bits;
            reg signed [2:0] factor;
            reg signed [15:0] pp;

            integer low_bit;

            low_bit = 2*iter - 1;

            if (low_bit < 0)
                booth_bits = { multiplier_ext[2*iter+1], multiplier_ext[2*iter], 1'b0 };
            else
                booth_bits = multiplier_ext[2*iter+1 -: 3]; // 3 bits starting at bit (2*iter+1) down to (2*iter-1)

            factor = booth_encode(booth_bits);

            pp = compute_partial(factor, multiplicand_ext);

            // Shift partial product left by 2*iter bits
            pp = pp <<< (2*iter);

            // Accumulate partial product into p
            p <= p + pp;

            if (iter == 4'd3) begin
                rdy <= 1'b1;
            end

            iter <= iter + 1;
        end
    end

endmodule