`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,  // N-bit fixed-point input a (two's complement)
    input  wire [N-1:0] b,  // N-bit fixed-point input b (two's complement)
    output wire [N-1:0] c   // N-bit fixed-point output c = a - b (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Convert to magnitude (absolute values)
    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    // Internal signals for magnitude result and sign of result
    reg [N-1:0] mag_res;
    reg sign_res;

    // Combinational block implementing subtraction with sign logic
    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                // Result sign same as inputs as per problem statement, so keep sign_res = sign_a
                sign_res = sign_a;
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = mag_a + mag_b;
            // Determine sign based on which input has greater magnitude
            if (mag_a > mag_b) begin
                sign_res = sign_a;
            end else if (mag_b > mag_a) begin
                sign_res = sign_b;
            end else begin
                // magnitudes equal, result zero
                mag_res = 0;
                sign_res = 1'b0; // sign bit cleared on zero
            end
        end

        // Handle zero magnitude: sign bit forced to 0
        if (mag_res == 0) begin
            sign_res = 1'b0;
        end
    end

    // Convert back to two's complement with sign_res and mag_res
    // If sign_res=0 => positive number = mag_res
    // If sign_res=1 => negative number = two's complement of mag_res
    assign c = sign_res ? (~mag_res + 1'b1) : mag_res;

endmodule


// Testbench for verification
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut(
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert fixed-point to real for easy checking
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = val;
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time |      a       |      b       |      c       | Expected");
        $display("---------------------------------------------------------------");

        // 1.5 - 0.5 = 1.0
        a = 16'sd(1.5 * (2**Q)); b = 16'sd(0.5 * (2**Q)); #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), 1.5-0.5);

        // -2.25 - 1.25 = -3.5
        a = -16'sd(2.25 * (2**Q)); b = 16'sd(1.25 * (2**Q)); #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), -2.25-1.25);

        // 0.75 - (-0.75) = 1.5
        a = 16'sd(0.75 * (2**Q)); b = -16'sd(0.75 * (2**Q)); #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), 0.75-(-0.75));

        // -1.0 - (-1.0) = 0.0
        a = -16'sd(1.0 * (2**Q)); b = -16'sd(1.0 * (2**Q)); #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 0.0 - 0.0 = 0.0
        a = 16'sd(0); b = 16'sd(0); #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Max positive - max negative
        a = 16'sd( (2**(N-1)) - 1 ); // Max positive
        b = -16'sd( (2**(N-1)) );    // Max negative (two's complement)
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, to_real(a), to_real(b), to_real(c), (to_real(a) - to_real(b)));

        $finish;
    end

endmodule