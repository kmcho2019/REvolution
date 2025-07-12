module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition
    wire signed [N:0] sum_full = a_signed + b_signed;
    
    // Detect overflow (when signs match but result sign differs)
    wire overflow = (a[N-1] == b[N-1]) && (sum_full[N-1] != a[N-1]);
    
    // Saturation value (max positive or negative)
    wire [N-1:0] sat_value = a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
    
    // Select result or saturated value
    assign c = overflow ? sat_value : sum_full[N-1:0];

endmodule