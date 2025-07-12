module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    wire signed [N-1:0] res;  // Intermediate result

    // Calculate the result of the subtraction
    assign res = a - b;

    // Handle the case where the result is zero
    assign c = (res == 0) ? 0 : res;

endmodule

// Testbench
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    // Explicitly define parameters during instantiation
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        a = 10;
        b = 5;
        #100;
        $display("Result when a > b and both are positive: %d", c);
        #100;
        a = -10;
        b = 5;
        #100;
        $display("Result when a < b and signs differ: %d", c);
        #100;
        a = 0;
        b = 0;
        #100;
        $display("Result when both a and b are zero: %d", c);
        $finish;
    end

endmodule