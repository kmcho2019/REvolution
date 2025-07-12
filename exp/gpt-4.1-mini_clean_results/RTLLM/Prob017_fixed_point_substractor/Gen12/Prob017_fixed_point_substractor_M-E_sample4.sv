`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,     // Fixed-point inputs (two's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c      // Fixed-point output (two's complement)
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1) : b[N-2:0];

    reg [N-1:0] mag_res;       // Full magnitude result with one extra bit for possible carry
    reg        res_sign;

    reg [N-1:0] mag_sub;       // temp for subtraction result magnitude
    reg        sub_negative;   // indicates if subtraction magnitude is negative

    // Extend magnitudes with MSB zero for subtraction
    reg [N-1:0] a_mag_ext;
    reg [N-1:0] b_mag_ext;

    always @(*) begin
        a_mag_ext = {1'b0, a_mag}; // extend magnitude to N bits for subtraction/addition
        b_mag_ext = {1'b0, b_mag};

        if (a_sign == b_sign) begin
            // Same sign subtraction: result_sign = a_sign
            // Compute magnitude difference: abs(a_mag - b_mag)
            if (a_mag_ext >= b_mag_ext) begin
                mag_res = a_mag_ext - b_mag_ext;
                res_sign = a_sign;
            end else begin
                mag_res = b_mag_ext - a_mag_ext;
                // Sign is same as inputs but since we subtracted bigger magnitude from smaller,
                // sign must be inverted
                res_sign = ~a_sign;
            end
        end else begin
            // Different sign subtraction => add magnitudes
            mag_res = a_mag_ext + b_mag_ext;
            // Result sign depends on which operand has larger magnitude:
            // But requirement states:
            // If a positive and b negative -> result sign positive if a > b, else negative
            // If a negative and b positive -> similar logic

            // We decide sign based on a and b original signs and magnitudes

            // Compare a_mag and b_mag to determine sign
            if (a_mag_ext >= b_mag_ext) begin
                // sign = a_sign
                // But since different signs, "a_sign" here means the sign of the first operand a
                // According to problem: If signs differ, result sign depends on which magnitude is greater,
                // and sign is the sign of the operand with larger magnitude
                res_sign = a_sign;
            end else begin
                res_sign = b_sign;
            end
        end

        // Compose output c with sign and magnitude (two's complement)
        if (mag_res == 0) begin
            // Zero result, sign bit explicitly zero
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            // Non-zero result

            // mag_res is N bits unsigned magnitude (max N bits)
            // Need to convert magnitude and sign back to two's complement
            if (res_sign == 0) begin
                // positive number: sign bit 0 + magnitude
                c = {1'b0, mag_res[N-2:0]};
            end else begin
                // negative number: two's complement of magnitude
                // Take mag_res magnitude bits and compute two's complement with sign bit 1
                // Two's complement negation of magnitude
                c = (~{1'b0, mag_res[N-2:0]} + 1);
            end
        end
    end

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

        a = {1'b0, {(N-1){1'b1}}}; // max positive
        b = {1'b1, {(N-1){1'b0}}}; // max negative (two's complement min)
        #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), fixed_to_real(a) - fixed_to_real(b));

        // Additional test: smaller magnitude with opposite signs
        a = real_to_fixed(-0.25); b = real_to_fixed(0.5); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), -0.25 - 0.5);

        a = real_to_fixed(0.1); b = real_to_fixed(0.1); #5;
        $display("%4t | %15f | %15f | %15f | %15f", $time, fixed_to_real(a), fixed_to_real(b), fixed_to_real(c), 0.0);

        $finish;
    end
endmodule