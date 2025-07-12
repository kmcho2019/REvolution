`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign bit
    parameter integer Q = 8    // Number of fractional bits (for documentation)
)(
    input  signed [N-1:0] a,   // Fixed-point input operand a (two's complement)
    input  signed [N-1:0] b,   // Fixed-point input operand b (two's complement)
    output signed [N-1:0] c    // Fixed-point subtraction result (a - b)
);

    // Direct signed subtraction
    wire signed [N-1:0] diff = a - b;

    // If result is zero, explicitly clear sign bit; else output diff directly.
    assign c = (diff == 0) ? {1'b0, {(N-1){1'b0}}} : diff;

endmodule


// Testbench for simulation only, excluded from synthesis
`ifdef SIM

module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    // Test inputs and output
    reg signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    // Instantiate DUT with parameters
    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Function: convert real number to fixed-point signed representation
    function signed [N-1:0] real_to_fixed(input real val);
        real scaled;
        begin
            scaled = val * (2.0 ** Q);
            if (scaled > (2.0 ** (N-1)) - 1)
                real_to_fixed = (2 ** (N-1)) - 1;
            else if (scaled < -(2.0 ** (N-1)))
                real_to_fixed = -(2 ** (N-1));
            else
                real_to_fixed = $rtoi(scaled);
        end
    endfunction

    // Function: convert fixed-point signed value to real number
    function real fixed_to_real(input signed [N-1:0] val);
        begin
            fixed_to_real = val / (2.0 ** Q);
        end
    endfunction

    initial begin
        $display("Time |        a        |        b        |        c        | Expected");
        $display("---------------------------------------------------------------");

        // Test cases with delays to allow signal propagation
        a = real_to_fixed(1.5);     b = real_to_fixed(0.5);   #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 1.5 - 0.5);

        a = real_to_fixed(-2.25);   b = real_to_fixed(1.25);  #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -2.25 - 1.25);

        a = real_to_fixed(0.75);    b = real_to_fixed(-0.75); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.75 - (-0.75));

        a = real_to_fixed(-1.0);    b = real_to_fixed(-1.0);  #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        a = real_to_fixed(0.0);     b = real_to_fixed(0.0);   #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        // Maximum positive and maximum negative test
        a = {1'b0, {(N-1){1'b1}}};  // Largest positive approx (all fraction bits set)
        b = {1'b1, {(N-1){1'b0}}};  // Most negative (two's complement min)
        #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        a = real_to_fixed(-0.25);   b = real_to_fixed(0.5);   #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1);     b = real_to_fixed(0.1);   #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        $finish;
    end

endmodule

`endif