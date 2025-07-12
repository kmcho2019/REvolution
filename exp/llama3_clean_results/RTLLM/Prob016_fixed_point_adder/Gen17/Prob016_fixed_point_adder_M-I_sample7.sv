module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the sign of the result
wire signed [N-1:0] res;

// Perform addition or subtraction based on the signs of a and b
assign res = (a[N-1] == b[N-1])? (a + b) : 
             (a[N-1] == 1'b0)? (a - (~b + 1'b1)) : ((~a + 1'b1) + b);

// Saturate the result to handle overflows
assign c = (res >= (1 << N) - 1)? (1 << N) - 1 : 
          (res < -((1 << N) - 1))? -(1 << N) + 1 : res[N-1:0];

endmodule

module testbench;
    parameter Q = 8, N = 16;
    reg [N-1:0] a, b;
    wire [N-1:0] c;

    fixed_point_adder #(.Q(Q),.N(N)) uut (
       .a(a),
       .b(b),
       .c(c)
    );

    initial begin
        a = 16'h1000; // Example value for a
        b = 16'h2000; // Example value for b
        #10;
        $display("Result: %h", c);
        #10;
        $finish;
    end
endmodule