module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Calculate integer part length based on total bits and fractional bits
    localparam INTEGER_PART_LENGTH = N - Q;

    // Extract integer and fractional parts
    wire signed [INTEGER_PART_LENGTH-1:0] a_int = a[N-1:Q];
    wire signed [INTEGER_PART_LENGTH-1:0] b_int = b[N-1:Q];
    wire signed [Q-1:0] a_frac = a[Q-1:0];
    wire signed [Q-1:0] b_frac = b[Q-1:0];

    // Perform subtraction on integer parts
    wire signed [INTEGER_PART_LENGTH-1:0] int_result = a_int - b_int;

    // Perform subtraction on fractional parts with handling for borrow from integer part
    wire signed [Q:0] frac_result = (a_frac + {Q{1'b0}}) - (b_frac + {Q{1'b0}});

    // Handle borrow from integer part if fractional part result is negative
    wire signed [INTEGER_PART_LENGTH-1:0] int_result_corrected = (frac_result < 0) ? int_result - 1 : int_result;
    wire signed [Q-1:0] frac_result_corrected = (frac_result < 0) ? frac_result + {Q{1'b1}} + 1 : frac_result[Q-1:0];

    // Combine results of integer and fractional parts
    assign c = (int_result_corrected < 0 && frac_result_corrected < 0) ? {int_result_corrected, frac_result_corrected} : 
               ({1'b0, int_result_corrected} + {frac_result_corrected, {INTEGER_PART_LENGTH{1'b0}}});

endmodule

// Example testbench code to demonstrate correct instantiation and usage.
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),  // First N-bit fixed-point input operand
       .b(b),  // Second N-bit fixed-point input operand
       .c(c)   // N-bit output representing the result of the fixed-point subtraction
    );

    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        #100;  // Delay to observe the output
        $display("Result: %d", c);  // Display the result
    end

endmodule