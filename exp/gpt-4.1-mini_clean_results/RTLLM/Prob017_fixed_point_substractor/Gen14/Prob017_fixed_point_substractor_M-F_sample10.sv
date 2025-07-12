`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,    // Total bits (including sign)
    parameter integer Q = 8      // Fractional bits
)(
    input  wire signed [N-1:0] a,   // Fixed-point signed input a (two's complement)
    input  wire signed [N-1:0] b,   // Fixed-point signed input b (two's complement)
    output reg  signed [N-1:0] c    // Fixed-point signed output c = a - b
);

    reg signed [N-1:0] res;

    always @* begin
        res = a - b;

        // Handle zero: if result is zero, force sign bit to zero
        if (res == 0) begin
            res = {1'b0, {(N-1){1'b0}}};
        end
    end

    always @* begin
        c = res;
    end

endmodule


// Testbench for verification
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert fixed-point two's complement to real number
    function real to_real(input signed [N-1:0] val);
        begin
            to_real = val / (2.0 ** Q);
        end
    endfunction

    // Convert real number to fixed-point two's complement
    function signed [N-1:0] to_fixed(input real val);
        begin
            to_fixed = $rtoi(val * (2.0 ** Q));
        end
    endfunction

    initial begin
        $display("Time | a (real)    | b (real)    | c (real)     | Expected c");
        $display("---------------------------------------------------------------");

        a = to_fixed( 1.5);   b = to_fixed( 0.5);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        a = to_fixed(-2.25);  b = to_fixed( 1.25);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        a = to_fixed( 0.75);  b = to_fixed(-0.75);  #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        a = to_fixed(-1.0);   b = to_fixed(-1.0);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 0.0);   b = to_fixed( 0.0);   #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        a = to_fixed( 127.5); b = to_fixed(-128.0); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 127.5 - (-128.0));

        a = to_fixed(-64.125); b = to_fixed(64.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), -64.125 - 64.125);

        a = to_fixed(0.0); b = to_fixed(0.125); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0 - 0.125);

        // Edge case: result zero with different signs
        a = to_fixed(0.5); b = to_fixed(0.5); #5;
        $display("%4t | %11f | %11f | %12f | %11f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        $finish;
    end

endmodule