module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Separate integer and fractional parts of inputs
    wire signed [N-Q-1:0] a_int;
    wire signed [Q-1:0] a_frac;
    wire signed [N-Q-1:0] b_int;
    wire signed [Q-1:0] b_frac;

    assign a_int = a >>> Q;  // Shift right to extract integer part
    assign a_frac = a & ((1 << Q) - 1);  // Mask to extract fractional part
    assign b_int = b >>> Q;  // Shift right to extract integer part
    assign b_frac = b & ((1 << Q) - 1);  // Mask to extract fractional part

    // Perform subtraction on integer parts
    wire signed [N-Q:0] int_result;
    assign int_result = a_int - b_int;

    // Perform subtraction on fractional parts
    wire signed [Q:0] frac_result;
    assign frac_result = a_frac - b_frac;

    // Combine results, handling overflow and underflow
    assign c = (int_result < -(1 << (N-Q-1))) ? -{1'b1, {N-1{1'b0}}} :
               (int_result > (1 << (N-Q-1)) - 1) ? {1'b1, {N-1{1'b1}}} :
               ((int_result << Q) + frac_result);

    // Handle sign based on input signs
    assign c = (a[N-1] == b[N-1] && a[N-1] == 1'b1 && c >= 0) ? -c :
               (a[N-1] != b[N-1] && a[N-1] == 1'b1 && c > 0) ? -c :
               (a[N-1] != b[N-1] && b[N-1] == 1'b1 && c < 0) ? -c : c;

    // Handle zero result
    assign c = (c == 0) ? 0 : c;

endmodule

// Testbench
module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  // Connect input a
        .b(b),  // Connect input b
        .c(c)   // Connect output c
    );

    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b

        #10;  // Wait for 10 time units
        $display("Result: %d", c);  // Display the result

        a = 10;
        b = 10;

        #10;  // Wait for 10 time units
        $display("Result when a == b: %d", c);  // Display the result when a equals b

        a = {1'b1, {N-1{1'b1}}};
        b = -{1'b1, {N-1{1'b0}}};

        #10;  // Wait for 10 time units
        $display("Result for overflow: %d", c);  // Display the result for overflow

        a = -{1'b1, {N-1{1'b0}}};
        b = {1'b1, {N-1{1'b1}}};

        #10;  // Wait for 10 time units
        $display("Result for underflow: %d", c);  // Display the result for underflow

        // Additional test cases
        a = 0;
        b = 0;

        #10;  // Wait for 10 time units
        $display("Result when a == 0 and b == 0: %d", c);  // Display the result when a equals 0 and b equals 0

        a = 5;
        b = -5;

        #10;  // Wait for 10 time units
        $display("Result when a > 0 and b < 0: %d", c);  // Display the result when a is positive and b is negative

        $finish;
    end
endmodule