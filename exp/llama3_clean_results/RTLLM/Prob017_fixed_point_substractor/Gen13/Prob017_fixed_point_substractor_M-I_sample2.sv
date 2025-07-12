module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(*) begin
    // Calculate the difference directly, leveraging Verilog's built-in signed arithmetic
    c = a - b;
    
    // Explicitly handle the zero result case for clarity
    if (c == 0) begin
        c = 0;  // Ensure the sign bit is 0 for a zero result
    end
end

endmodule

// Testbench
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
        // Test various scenarios, including edge cases
        a = 10; b = 5;
        #10; $display("Result (10 - 5): %d", c);
        
        a = -10; b = 5;
        #10; $display("Result (-10 - 5): %d", c);
        
        a = 0; b = 0;
        #10; $display("Result (0 - 0): %d", c);
        
        a = -5; b = -10;
        #10; $display("Result (-5 - (-10)): %d", c);
        
        a = {N{1'b1}};  // Maximum negative value
        b = {N{1'b0}};  // Zero
        #10; $display("Result (min - 0): %d", c);
        
        a = {N{1'b0}};  // Zero
        b = {N{1'b1}};  // Maximum negative value (two's complement)
        #10; $display("Result (0 - min): %d", c);
        
        $finish;
    end
    
endmodule