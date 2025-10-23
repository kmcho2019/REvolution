module fixed_point_adder #(
    parameter Q = 8,           // Number of fractional bits
    parameter N = 16           // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,    // First fixed-point operand
    input  wire [N-1:0] b,    // Second fixed-point operand
    output reg  [N-1:0] c     // Fixed-point addition result
);

    // Sign-extend inputs by 1 bit to N+1 bits to detect overflow
    wire signed [N:0] a_ext = {{1{a[N-1]}}, a};
    wire signed [N:0] b_ext = {{1{b[N-1]}}, b};

    // Internal register for the sum with one extra bit for overflow
    reg signed [N:0] res;

    // Define signed saturation limits for N bits
    // Max positive value: sign=0, rest = 1's
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};
    // Most negative value: sign=1, rest = 0's
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};

    // Extend saturation limits to N+1 bits, sign-extended
    localparam signed [N:0] MAX_EXT = {{1{1'b0}}, MAX_VAL}; // MSB 0 padded
    localparam signed [N:0] MIN_EXT = {{1{1'b1}}, MIN_VAL}; // MSB 1 padded

    always @(*) begin
        res = a_ext + b_ext;

        // Overflow detection: if sign bit (res[N]) differs from next bit (res[N-1])
        if (res[N] != res[N-1]) begin
            // Overflow occurred: saturate result
            if (res[N]) begin
                // Negative overflow: clamp to most negative value
                res = MIN_EXT;
            end else begin
                // Positive overflow: clamp to max positive value
                res = MAX_EXT;
            end
        end

        // Assign the lower N bits as output, discarding overflow bit
        c = res[N-1:0];
    end

endmodule