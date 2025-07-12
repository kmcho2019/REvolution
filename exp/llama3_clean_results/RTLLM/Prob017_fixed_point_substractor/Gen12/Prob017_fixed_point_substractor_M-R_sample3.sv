module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

assign c = a - b;

endmodule

// Testbench remains the same
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
        #10; $display("Result (10 - 5): %d", c);
        a = -10; b = 5;
        #10; $display("Result (-10 - 5): %d", c);
        a = 0; b = 0;
        #10; $display("Result (0 - 0): %d", c);
        a = -5; b = -10;
        #10; $display("Result (-5 - (-10)): %d", c);
        $finish;
    end
    
endmodule