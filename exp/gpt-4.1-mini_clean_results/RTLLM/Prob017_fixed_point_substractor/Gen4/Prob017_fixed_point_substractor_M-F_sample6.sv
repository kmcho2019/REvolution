`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits: sign + integer + fractional
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,  // fixed-point inputs (2's complement)
    input  wire [N-1:0] b,
    output reg  [N-1:0] c   // fixed-point output (2's complement)
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitude (absolute value) of inputs as signed values
    wire signed [N-2:0] a_mag = a_sign ? $signed(~a[N-2:0] + 1'b1) : $signed(a[N-2:0]);
    wire signed [N-2:0] b_mag = b_sign ? $signed(~b[N-2:0] + 1'b1) : $signed(b[N-2:0]);

    reg result_sign;
    reg signed [N-2:0] result_mag;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes, keep sign of inputs
            if (a_mag >= b_mag) begin
                result_mag = a_mag - b_mag;
                result_sign = a_sign;
            end else begin
                result_mag = b_mag - a_mag;
                result_sign = b_sign;
            end
        end else begin
            // Different signs: add magnitudes
            result_mag = a_mag + b_mag;
            // Sign of result depends on which magnitude is larger
            if (a_mag >= b_mag) begin
                result_sign = a_sign;
            end else begin
                result_sign = b_sign;
            end
        end

        // Handle zero result explicitly: sign = 0, magnitude = 0
        if (result_mag == 0) begin
            result_sign = 1'b0;
            result_mag = { (N-1){1'b0} };
        end

        // Compose 2's complement result from sign and magnitude
        if (result_sign == 1'b0) begin
            // Positive number: straightforward magnitude
            c = {1'b0, result_mag};
        end else begin
            // Negative number: two's complement of magnitude
            c = {1'b1, (~result_mag + 1'b1)};
        end
    end

endmodule


// Simple testbench for the fixed_point_subtractor with sign/magnitude logic
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Function to convert fixed-point number (2's complement) to real for display
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = $signed(val);
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected c");
        $display("-----------------------------------------------------------");

        // Test 1: 1.5 - 0.5 = 1.0
        a = 16'd384;    // 1.5 * 256
        b = 16'd128;    // 0.5 * 256
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // Test 2: -2.25 - 1.25 = -3.5
        a = 16'sd(-576); // -2.25 * 256
        b = 16'd320;     // 1.25 * 256
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // Test 3: 0.75 - (-0.75) = 1.5
        a = 16'd192;     // 0.75 * 256
        b = 16'sd(-192); // -0.75 * 256
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // Test 4: -1.0 - (-1.0) = 0.0
        a = 16'sd(-256); // -1.0 * 256
        b = 16'sd(-256); // -1.0 * 256
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Test 5: 0.0 - 0.0 = 0.0
        a = 16'd0;
        b = 16'd0;
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // Test 6: Max positive - Max negative (no saturation)
        a = 16'sd(32767);   // max positive 16-bit signed
        b = 16'sd(-32768);  // max negative 16-bit signed
        #5;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c),
            (32767 / (2.0**Q)) - (-32768 / (2.0**Q)));

        $finish;
    end

endmodule