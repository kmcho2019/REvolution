// Fixed-point subtractor module using signed arithmetic, synthesis-friendly style
module fixed_point_subtractor #(
    parameter integer N = 16, // total bits (including sign)
    parameter integer Q = 8   // fractional bits
)(
    input  wire signed [N-1:0] a,  // signed fixed-point input a
    input  wire signed [N-1:0] b,  // signed fixed-point input b
    output reg  signed [N-1:0] c   // signed fixed-point output c = a - b
);

    // Internal signed register for result
    reg signed [N-1:0] res;

    always @* begin
        res = a - b;

        // If result is zero, explicitly clear sign bit to 0
        if (res == 0)
            res[N-1] = 1'b0;

        c = res;
    end

endmodule


// Testbench demonstrating correct parameter instantiation and verification
module tb_fixed_point_subtractor;

    parameter integer N = 16;
    parameter integer Q = 8;

    reg  signed [N-1:0] a, b;
    wire signed [N-1:0] c;

    // Instantiate fixed_point_subtractor with explicit parameters
    fixed_point_subtractor #(.N(N), .Q(Q)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Function to convert signed fixed-point to real number for display
    function real to_real(input signed [N-1:0] val);
        integer i;
    begin
        to_real = val;
        for (i=0; i<Q; i=i+1) begin
            to_real = to_real / 2.0;
        end
    end
    endfunction

    initial begin
        $display("Time\t  a (dec)\t b (dec)\t c (dec)\t a-b (real)");
        $display("---------------------------------------------------------------");

        // Test case 1: 1.5 - 0.5 = 1.0
        a = 16'sh0180; // 1.5 * 2^8 = 384 decimal = 0x0180
        b = 16'sh0080; // 0.5 * 2^8 = 128 decimal = 0x0080
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // Test case 2: -2.25 - 1.25 = -3.5
        a = -16'sd(2.25 * 2**Q); // -2.25 fixed-point representation
        b =  16'sd(1.25 * 2**Q); // 1.25 fixed-point representation
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // Test case 3: 0.75 - (-0.75) = 1.5
        a =  16'sd(0.75 * 2**Q);
        b = -16'sd(0.75 * 2**Q);
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // Test case 4: -1.0 - (-1.0) = 0.0
        a = -16'sd(1.0 * 2**Q);
        b = -16'sd(1.0 * 2**Q);
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // Test case 5: 0 - 0 = 0
        a = 16'sd(0);
        b = 16'sd(0);
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        $finish;
    end

endmodule