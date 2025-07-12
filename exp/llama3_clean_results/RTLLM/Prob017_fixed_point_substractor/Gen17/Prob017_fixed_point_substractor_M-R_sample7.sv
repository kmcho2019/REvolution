module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Use continuous assignment for combinational logic
assign c = a - b;

endmodule

// Testbench with proper module instantiation and parameter passing
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    // Instantiate the module with parameters
    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        // Initialize inputs
        a = 10;
        b = 5;
        
        // Wait for 100 time units
        #100;
        
        // Display the result
        $display("Result: %d", c);
        
        // Finish the simulation
        $finish;
    end

endmodule