`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits (not directly used in logic)
)(
    input  wire [N-1:0] a,     // Fixed-point inputs (two's complement)
    input  wire [N-1:0] b,
    output wire [N-1:0] c      // Fixed-point output (two's complement)
);

    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] res_signed;

    assign res_signed = a_signed - b_signed;

    // If result is zero, explicitly clear sign bit to 0
    assign c = (res_signed == 0) ? {1'b0, {(N-1){1'b0}}} : res_signed;

endmodule


// Testbench to verify the implementation

module tb_fixed_point_subtractor;
    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Convert real number to fixed-point two's complement signed representation
    function [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            if (scaled > (2.0**(N-1)-1))
                real_to_fixed = (2**(N-1)) - 1;
            else if (scaled < -(2.0**(N-1)))
                real_to_fixed = -(2**(N-1));
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Convert fixed-point two's complement to real number
    function real fixed_to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
        begin
            sval = val;
            fixed_to_real = sval / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |        a        |        b        |        c        | Expected");
        $display("---------------------------------------------------------------");

        a = real_to_fixed(1.5); b = real_to_fixed(0.5); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        a = real_to_fixed(-2.25); b = real_to_fixed(1.25); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        a = real_to_fixed(0.75); b = real_to_fixed(-0.75); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        a = real_to_fixed(-1.0); b = real_to_fixed(-1.0); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(0.0); b = real_to_fixed(0.0); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = {1'b0, {(N-1){1'b1}}}; // max positive (~0.9999)
        b = {1'b1, {(N-1){1'b0}}}; // max negative (most negative number)
        #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        // Additional test: smaller magnitude with opposite signs
        a = real_to_fixed(-0.25); b = real_to_fixed(0.5); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1); b = real_to_fixed(0.1); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_fixed(b), fixed_to_real(c), 0.0);

        $finish;
    end
endmodule