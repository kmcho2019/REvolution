// Fixed-point subtractor module with parameterized bit widths and fractional bits
module fixed_point_subtractor #(
    parameter integer N = 16, // total bits
    parameter integer Q = 8   // fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values (magnitude) of inputs
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Temporary variables for result magnitude and sign
    reg [N-2:0] res_mag;
    reg         res_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: a - b
            // Treat inputs as signed values using signed arithmetic
            reg signed [N-1:0] signed_a;
            reg signed [N-1:0] signed_b;
            reg signed [N-1:0] signed_res;

            signed_a = $signed(a);
            signed_b = $signed(b);
            signed_res = signed_a - signed_b;

            res_sign = signed_res[N-1];
            res_mag = signed_res[N-2:0];
        end else begin
            // Different sign subtraction = addition of magnitudes with sign depending on larger magnitude
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = b_sign;
            end
        end

        // Explicitly clear sign bit if result is zero
        if (res_mag == 0)
            res_sign = 1'b0;

        // Compose final result
        res = {res_sign, res_mag};
    end

    always @* begin
        c = res;
    end

endmodule


// Testbench demonstrating correct parameter instantiation and basic tests
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;

    // Instantiate fixed_point_subtractor with parameters passed explicitly
    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Helper task to display fixed-point number as signed real for verification
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = $signed(val);
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    initial begin
        // Display headers
        $display("Time\t a\t\t b\t\t c\t\t (Real) a - b");
        $display("-------------------------------------------------------------");

        // Test 1: 1.5 - 0.5 = 1.0
        a = 16'h0180; // 1.5 in Q8 (1.5 * 256 = 384 decimal = 0x180)
        b = 16'h0080; // 0.5 in Q8
        #1;
        $display("%0t\t%0d\t %0d\t %0d\t %f", $time, to_real(a), to_real(b), to_real(c), to_real(c));

        // Test 2: -2.25 - 1.25 = -3.5
        a = 16'hFE40; // -2.25 in Q8 (signed: -2.25*256 = -576 = 0xFE40)
        b = 16'h0140; // 1.25
        #1;
        $display("%0t\t%0d\t %0d\t %0d\t %f", $time, to_real(a), to_real(b), to_real(c), to_real(c));

        // Test 3: 0.75 - (-0.75) = 1.5
        a = 16'h00C0; // 0.75
        b = 16'hFF40; // -0.75
        #1;
        $display("%0t\t%0d\t %0d\t %0d\t %f", $time, to_real(a), to_real(b), to_real(c), to_real(c));

        // Test 4: -1.0 - (-1.0) = 0.0
        a = 16'hFF00; // -1.0
        b = 16'hFF00; // -1.0
        #1;
        $display("%0t\t%0d\t %0d\t %0d\t %f", $time, to_real(a), to_real(b), to_real(c), to_real(c));

        // Test 5: 0 - 0 = 0
        a = 16'h0000;
        b = 16'h0000;
        #1;
        $display("%0t\t%0d\t %0d\t %0d\t %f", $time, to_real(a), to_real(b), to_real(c), to_real(c));

        $finish;
    end

endmodule