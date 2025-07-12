`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @(*) begin
        // Direct signed subtraction for fixed-point operands
        c = a - b;

        // Explicitly clear sign bit if result is zero to avoid negative zero
        if (c == 0)
            c = {1'b0, {(N-1){1'b0}}};
    end

endmodule


// Testbench to verify behavior with correct fixed-point conversion
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert real number to fixed-point signed integer (rounding toward zero)
    function signed [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            // Clamp to representable range of signed N-bit number
            if (scaled > (2.0**(N-1)-1))
                real_to_fixed = (2**(N-1)) - 1;
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = -(2**(N-1));
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Convert fixed-point signed integer to real
    function real fixed_to_real(input signed [N-1:0] val);
        begin
            fixed_to_real = val / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |       a       |       b       |       c       | Expected");
        $display("-----------------------------------------------------------------");

        // Test case 1: 1.5 - 0.5 = 1.0
        a = real_to_fixed(1.5);
        b = real_to_fixed(0.5);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        // Test case 2: -2.25 - 1.25 = -3.5
        a = real_to_fixed(-2.25);
        b = real_to_fixed(1.25);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        // Test case 3: 0.75 - (-0.75) = 1.5
        a = real_to_fixed(0.75);
        b = real_to_fixed(-0.75);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        // Test case 4: -1.0 - (-1.0) = 0.0 (check zero sign bit)
        a = real_to_fixed(-1.0);
        b = real_to_fixed(-1.0);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Test case 5: 0.0 - 0.0 = 0.0 (zero case)
        a = real_to_fixed(0.0);
        b = real_to_fixed(0.0);
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Test case 6: Max positive - max negative
        a = (2**(N-1)) - 1;       // max positive integer in N-bit signed
        b = - (2**(N-1));         // max negative integer in N-bit signed (2's complement min)
        #5;
        $display("%4t | %12f | %12f | %12f | %12f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        $finish;
    end

endmodule