module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits (for documentation clarity, not directly used in this implementation)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction using explicit arithmetic for clarity and synthesizability
// This implementation directly uses Verilog's signed arithmetic, which handles signs and magnitudes correctly.
always @(a or b) begin
    c = a - b;
    // Explicitly handle zero result for clarity, though Verilog's arithmetic should handle this correctly
    if (c == 0) begin
        c = 0; // Ensure sign bit is 0 for zero result
    end
end

endmodule

// Example testbench to demonstrate instantiation and parameter handling
module testbench;
    parameter Q = 8;
    parameter N = 16;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );
    
    initial begin
        a = 10; b = 5;
        #10; $display("Result: %d", c);
        a = -10; b = 5;
        #10; $display("Result: %d", c);
        a = 0; b = 0;
        #10; $display("Result: %d", c);
    end
    
endmodule