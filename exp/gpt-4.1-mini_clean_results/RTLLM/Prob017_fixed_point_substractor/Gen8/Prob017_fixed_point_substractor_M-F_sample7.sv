// Fixed-point subtractor module as previously implemented
module fixed_point_subtractor #(
    parameter Q = 8,          // Fractional bits
    parameter N = 16          // Total bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,   // Signed fixed-point operand a
    input  wire signed [N-1:0] b,   // Signed fixed-point operand b
    output wire signed [N-1:0] c    // Signed fixed-point subtraction result
);

    // Extract signs directly from signed inputs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values using signed arithmetic
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // Result magnitude and sign wires
    wire [N-1:0] magnitude_sub = (a_ge_b) ? (a_abs - b_abs) : (b_abs - a_abs);
    wire [N-1:0] magnitude_add = a_abs + b_abs;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Calculate intermediate result magnitude depending on sign relation
    wire [N-1:0] res_mag = same_sign ? magnitude_sub : magnitude_add;

    // Determine result sign
    wire res_sign;
    assign res_sign = same_sign
                      ? (a_ge_b ? a_sign : ~a_sign)
                      : ((~a_sign && b_sign) ? (a_ge_b ? 1'b0 : 1'b1)
                                            : (a_ge_b ? 1'b1 : 1'b0));

    // Detect zero magnitude
    wire zero_mag = (res_mag == 0);

    // Compose final result, zero forces sign bit zero explicitly
    assign c = zero_mag
               ? {1'b0, {(N-1){1'b0}}}
               : (res_sign ? (~res_mag + 1'b1) : res_mag);

endmodule


// Testbench demonstrating explicit parameter passing and module instantiation
module tb_fixed_point_subtractor;

    // Parameter definitions to pass explicitly
    parameter Q = 8;
    parameter N = 16;

    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;

    // Instantiate the module with explicit parameters
    fixed_point_subtractor #(
        .Q(Q),
        .N(N)
    ) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        // Test vectors with comments: decimal values represented in Q format (Q=8)
        // e.g., 1.5 = 1*2^8 + 0.5*2^8 = 384 (decimal)
        
        // Test 1: a = 1.5, b = 0.5, expect 1.0
        a = 16'sd384;  // 1.5
        b = 16'sd128;  // 0.5
        #10;
        $display("Test1: a=1.5, b=0.5, c=%f", $itor(c)/(1<<Q));

        // Test 2: a = -1.0, b = 0.5, expect -1.5
        a = -16'sd256; // -1.0
        b = 16'sd128;  // 0.5
        #10;
        $display("Test2: a=-1.0, b=0.5, c=%f", $itor(c)/(1<<Q));

        // Test 3: a = 0.75, b = -0.25, expect 1.0
        a = 16'sd192;  // 0.75
        b = -16'sd64;  // -0.25
        #10;
        $display("Test3: a=0.75, b=-0.25, c=%f", $itor(c)/(1<<Q));

        // Test 4: a = -0.5, b = -0.5, expect 0 (with sign bit 0)
        a = -16'sd128; // -0.5
        b = -16'sd128; // -0.5
        #10;
        $display("Test4: a=-0.5, b=-0.5, c=%f, sign_bit=%b", $itor(c)/(1<<Q), c[N-1]);

        // Test 5: a = 0, b = 0, expect 0 (sign bit 0)
        a = 16'sd0;
        b = 16'sd0;
        #10;
        $display("Test5: a=0, b=0, c=%f, sign_bit=%b", $itor(c)/(1<<Q), c[N-1]);

        $finish;
    end

endmodule