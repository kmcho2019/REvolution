module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c  // Declare output as reg for procedural assignment
);

reg signed [N-1:0] res; // Internal register to store the result

always @(a or b) begin
    // Direct computation of subtraction, which is straightforward and generally synthesizable
    res = a - b;
    
    // Explicitly handle the zero result case for clarity and to ensure correct sign representation
    if (res == 0) begin
        c = 0; // Ensure sign bit is 0 for zero result
    end else begin
        c = res; // Otherwise, assign the result directly
    end
end

endmodule

// Example testbench to demonstrate correct parameter handling
module tb;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16; // Total number of bits

    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;

    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        a = 10; // Example value for a
        b = 5;  // Example value for b
        #10;    // Wait for 10 time units
        $display("Result: %d", c); // Display the result
        $finish;
    end
endmodule