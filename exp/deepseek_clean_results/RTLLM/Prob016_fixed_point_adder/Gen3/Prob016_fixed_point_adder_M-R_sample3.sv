module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

// Sign bits
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Magnitudes (absolute values)
wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

// Sum and difference calculations
wire [N:0] sum_full = {1'b0, a_mag} + {1'b0, b_mag};
wire [N:0] diff_full = a_mag > b_mag ? 
                      {1'b0, a_mag} - {1'b0, b_mag} : 
                      {1'b0, b_mag} - {1'b0, a_mag};

// Overflow detection for addition (MSB of extended sum)
wire add_overflow = sum_full[N];

// Result selection
wire same_sign = (a_sign == b_sign);
wire a_larger = (a_mag > b_mag);

// Addition result (with overflow saturation)
wire [N-1:0] add_result = add_overflow ? 
                         {a_sign, {(N-1){1'b1}}} : 
                         {a_sign, sum_full[N-1:0]};

// Subtraction result
wire [N-1:0] sub_result = (a_mag == b_mag) ? {N{1'b0}} :  // Zero case
                         (a_larger ? {a_sign, diff_full[N-1:0]} : 
                                     {b_sign, diff_full[N-1:0]});

// Final output selection
assign c = same_sign ? add_result : sub_result;

endmodule