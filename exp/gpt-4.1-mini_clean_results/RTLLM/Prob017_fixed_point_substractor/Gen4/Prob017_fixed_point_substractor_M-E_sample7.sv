`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign bit
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // N-bit fixed-point input a (two's complement)
    input  wire [N-1:0] b,    // N-bit fixed-point input b (two's complement)
    input  wire           clk, // Clock for registering output
    input  wire           rst_n, // Active-low reset
    output reg  [N-1:0]   c   // N-bit fixed-point output c (two's complement)
);

    // Internal signals
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitudes (absolute value)
    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    reg [N-1:0] mag_res;   // Magnitude of result
    reg        sign_res;   // Sign of result
    reg        zero_flag;  // Indicates zero result

    reg [N-1:0] res;       // Internal register for result magnitude + sign

    // Combinational block to compute magnitude and sign based on input signs
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: subtract smaller magnitude from larger magnitude
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a; // same sign as inputs
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = sign_a; // same sign as inputs
            end
        end else begin
            // Different sign: add magnitudes
            mag_res = mag_a + mag_b;

            // Determine sign based on which has larger magnitude
            if (mag_a >= mag_b)
                sign_res = sign_a;
            else
                sign_res = sign_b;
        end

        // Zero detection: if mag_res is zero, clear sign_res
        zero_flag = (mag_res == 0);
        if (zero_flag)
            sign_res = 1'b0;

        // Convert sign/magnitude back to two's complement
        if (sign_res) begin
            // negative result: two's complement magnitude
            res = ~mag_res + 1'b1;
        end else begin
            // positive result
            res = mag_res;
        end
    end

    // Register output for timing and stability
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c <= {N{1'b0}};
        end else begin
            c <= res;
        end
    end

endmodule


// Testbench to verify the fixed_point_subtractor with sign and zero handling
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  [N-1:0] a, b;
    wire [N-1:0] c;
    reg          clk;
    reg          rst_n;

    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .c(c)
    );

    // Convert two's complement fixed-point to real for display
    function real to_real(input [N-1:0] val);
        reg signed [N-1:0] sval;
    begin
        sval = val;
        to_real = sval / (2.0 ** Q);
    end
    endfunction

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        #15;
        rst_n = 1;
    end

    initial begin
        $display("Time | a (real)  | b (real)  | c (real)   | Expected c");
        $display("-----------------------------------------------------------");

        // Wait for reset release
        @(posedge rst_n);

        // Test cases (apply inputs, wait for output register update)

        // 1) a=1.5, b=0.5 => c=1.0
        a = 16'sd384;    // 1.5*256 = 384
        b = 16'sd128;    // 0.5*256 = 128
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 1.5 - 0.5);

        // 2) a=-2.25, b=1.25 => c=-3.5
        a = -16'sd576;   // -2.25*256 = -576
        b = 16'sd320;    // 1.25*256 = 320
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.25 - 1.25);

        // 3) a=0.75, b=-0.75 => c=1.5
        a = 16'sd192;    // 0.75*256 = 192
        b = -16'sd192;   // -0.75*256 = -192
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.75 - (-0.75));

        // 4) a=-1.0, b=-1.0 => c=0.0 (zero sign bit forced 0)
        a = -16'sd256;   // -1.0*256 = -256
        b = -16'sd256;   // -1.0*256 = -256
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 5) a=0.0, b=0.0 => c=0.0
        a = 16'sd0;
        b = 16'sd0;
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.0);

        // 6) Max positive - max negative
        a = 16'sd32767;   // max positive 16-bit signed
        b = -16'sd32768;  // max negative 16-bit signed
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), (32767/(2.0**Q))-(-32768/(2.0**Q)));

        // 7) a < b with different sign (a positive, b negative, a < b)
        a = 16'sd128;    // 0.5
        b = -16'sd256;   // -1.0
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), 0.5 - (-1.0));

        // 8) a < b same sign negative (expect negative result)
        a = -16'sd512;   // -2.0
        b = -16'sd640;   // -2.5
        @(posedge clk); #1;
        $display("%4t | %9f | %9f | %9f | %9f", $time, to_real(a), to_real(b), to_real(c), -2.0 - (-2.5));

        $finish;
    end

endmodule