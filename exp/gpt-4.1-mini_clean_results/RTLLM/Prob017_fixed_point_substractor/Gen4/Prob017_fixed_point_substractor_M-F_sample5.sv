module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits including sign
    parameter integer Q = 8    // fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    reg signed [N-1:0] res;

    always @* begin
        res = a - b;
        if (res == 0)
            res[N-1] = 1'b0;  // clear sign bit on zero result
        c = res;
    end

endmodule


// Testbench for fixed_point_subtractor
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

    // Convert fixed-point value to real for printing
    function real to_real(input signed [N-1:0] val);
        begin
            to_real = val;
            to_real = to_real / (2.0**Q);
        end
    endfunction

    initial begin
        $display("Time\t a (dec)\t b (dec)\t c (dec)\t a-b (real)");
        $display("-------------------------------------------------------");

        // Test vectors declared as integers for readability
        integer a_int, b_int;

        // 1.5 - 0.5 = 1.0
        a_int = (1 * (2**Q)) + (2**(Q-1));  // 1.5 in fixed-point integer form
        b_int = (0 * (2**Q)) + (2**(Q-1));  // 0.5
        a = a_int;
        b = b_int;
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // -2.25 - 1.25 = -3.5
        a_int = -((2 * (2**Q)) + (2**(Q-2))); // -2.25
        b_int =  (1 * (2**Q)) + (2**(Q-2));   // 1.25
        a = a_int;
        b = b_int;
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // 0.75 - (-0.75) = 1.5
        a_int = (0 * (2**Q)) + (2**(Q-1)) + (2**(Q-2));  // 0.75
        b_int = -((0 * (2**Q)) + (2**(Q-1)) + (2**(Q-2))); // -0.75
        a = a_int;
        b = b_int;
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // -1.0 - (-1.0) = 0.0
        a_int = -(1 * (2**Q));  // -1.0
        b_int = -(1 * (2**Q));  // -1.0
        a = a_int;
        b = b_int;
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        // 0 - 0 = 0
        a_int = 0;
        b_int = 0;
        a = a_int;
        b = b_int;
        #1;
        $display("%0t\t %0d\t %0d\t %0d\t %f", $time, a, b, c, to_real(c));

        $finish;
    end

endmodule