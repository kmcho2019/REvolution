// Define the hybrid adder module
module HybridAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the hybrid adder
    wire [3:0] sum_lsb;
    wire [3:0] sum_msb;
    wire [3:0] carry_lsb;
    wire [3:0] carry_msb;

    // Ripple-carry adder for lower bits
    ripple_carry_adder rca(
       .a(a[3:0]),
       .b(b[3:0]),
       .cin(1'b0),
       .sum(sum_lsb),
       .cout(carry_lsb)
    );

    // Carry-lookahead adder for higher bits
    carry_lookahead_adder cla(
       .a(a[7:4]),
       .b(b[7:4]),
       .cin(carry_lsb[3]),
       .sum(sum_msb),
       .cout(carry_msb)
    );

    // Combine the results
    assign sum[3:0] = sum_lsb;
    assign sum[7:4] = sum_msb;

endmodule

// Define the sign-magnitude adder module
module SignMagnitudeAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the sign-magnitude adder
    wire sign_a;
    wire sign_b;
    wire [7:0] magnitude_a;
    wire [7:0] magnitude_b;
    wire [7:0] sum_magnitude;

    // Extract the sign and magnitude bits
    assign sign_a = a[7];
    assign sign_b = b[7];
    assign magnitude_a = a[6:0];
    assign magnitude_b = b[6:0];

    // Perform addition on the magnitude bits
    HybridAdder ha(
       .a(magnitude_a),
       .b(magnitude_b),
       .sum(sum_magnitude)
    );

    // Combine the results
    assign sum[7] = sign_a ^ sign_b;
    assign sum[6:0] = sum_magnitude;

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the adders and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum_twos_complement;
    wire [7:0] sum_sign_magnitude;

    HybridAdder ha_twos_complement(
       .a(a),
       .b(b),
       .sum(sum_twos_complement)
    );

    SignMagnitudeAdder ha_sign_magnitude(
       .a(a),
       .b(b),
       .sum(sum_sign_magnitude)
    );

    OverflowDetector detector(
       .a(a),
       .b(b),
       .sum(sum_twos_complement),
       .overflow(overflow)
    );

    assign s = sum_twos_complement;

endmodule