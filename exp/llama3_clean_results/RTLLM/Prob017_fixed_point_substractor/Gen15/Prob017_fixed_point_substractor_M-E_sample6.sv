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

    // Internal wires for integer and fractional parts of inputs a and b
    wire signed [INTEGER_PART_LENGTH-1:0] a_int, b_int;
    wire signed [Q-1:0] a_frac, b_frac;

    // Assign integer and fractional parts
    assign a_int = a[N-1:Q];
    assign b_int = b[N-1:Q];
    assign a_frac = a[Q-1:0];
    assign b_frac = b[Q-1:0];

    // Perform subtraction on integer parts
    reg signed [INTEGER_PART_LENGTH-1:0] int_result;
    always @(*) begin
        int_result = a_int - b_int;
    end

    // Perform subtraction on fractional parts with handling for borrow from integer part
    reg signed [Q:0] frac_result;
    always @(*) begin
        frac_result = (a_frac + {Q{1'b0}}) - (b_frac + {Q{1'b0}});
        if (frac_result < 0) begin
            frac_result += {Q{1'b1}} + 1; // Handle borrow from integer part
            int_result -= 1;
        end
    end

    // Combine results of integer and fractional parts
    always @(*) begin
        if (int_result < 0) begin
            c = {int_result, frac_result[Q-1:0]};
        end else if (int_result >= 0) begin
            c = {int_result, frac_result[Q-1:0]};
        end else begin
            c = 0; // Handle zero result case explicitly
        end
    end

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