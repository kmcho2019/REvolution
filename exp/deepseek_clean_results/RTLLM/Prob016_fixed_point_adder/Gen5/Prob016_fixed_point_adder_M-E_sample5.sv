module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Conditional inversion for subtraction
    wire [N-2:0] b_operand = (a_sign ^ b_sign) ? ~b_mag : b_mag;
    wire carry_in = (a_sign ^ b_sign) ? 1'b1 : 1'b0;

    // Parallel prefix adder (Kogge-Stone architecture)
    wire [N-1:0] gen, prop;
    wire [N-1:0] carry;

    assign gen[0] = a_mag[0] & b_operand[0];
    assign prop[0] = a_mag[0] ^ b_operand[0];
    assign carry[0] = gen[0] | (prop[0] & carry_in);

    generate
        genvar i;
        for (i = 1; i < N-1; i = i+1) begin : adder_stages
            assign gen[i] = a_mag[i] & b_operand[i];
            assign prop[i] = a_mag[i] ^ b_operand[i];
            assign carry[i] = gen[i] | (prop[i] & carry[i-1]);
        end
    endgenerate

    // Sum computation
    wire [N-2:0] sum_mag;
    assign sum_mag[0] = prop[0] ^ carry_in;
    generate
        for (i = 1; i < N-1; i = i+1) begin : sum_bits
            assign sum_mag[i] = prop[i] ^ carry[i-1];
        end
    endgenerate

    // Overflow prediction (before actual addition)
    wire potential_overflow = (a_sign == b_sign) & 
                             (a_mag[N-2] & b_mag[N-2] | 
                             (a_mag[N-2] | b_mag[N-2]) & carry[N-3]);

    // Result sign determination
    wire res_sign;
    wire a_gt_b = (a_mag > b_mag) | (a_mag == b_mag & a_sign & ~b_sign);
    assign res_sign = (a_sign ^ b_sign) ? (a_gt_b ? a_sign : b_sign) : a_sign;

    // Final result assembly
    always @(*) begin
        if (potential_overflow) begin
            // Saturate to maximum magnitude
            c = {res_sign, {(N-1){~res_sign}}};
        end else if (a_sign ^ b_sign) begin
            // Subtraction case
            if (a_mag == b_mag) begin
                c = {N{1'b0}};
            end else begin
                c = {res_sign, sum_mag};
            end
        end else begin
            // Addition case
            c = {res_sign, sum_mag};
        end
    end

    // Rounding correction (optional)
    // wire round_bit = sum_mag[Q-1] & (|sum_mag[Q-2:0]);
    // c = c + round_bit;

endmodule