module fixed_point_subtractor #(
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction using explicit arithmetic for clarity and synthesizability
always @(*) begin
    c = a - b;
    // Explicitly handle zero result for clarity
    if (c == 0) begin
        c = 0; // Ensure sign bit is 0 for zero result
    end
end

endmodule

// Example testbench to demonstrate instantiation and parameter handling
module testbench;
    parameter N = 16;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.N(N)) uut (
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
        $finish;
    end
    
endmodule