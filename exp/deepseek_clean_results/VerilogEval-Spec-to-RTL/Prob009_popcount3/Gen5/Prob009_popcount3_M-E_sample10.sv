module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // First level: count pairs
    wire [1:0] count01 = in[0] + in[1];
    wire [1:0] count2  = {1'b0, in[2]};

    // Second level: combine counts using mux-based adder
    wire carry = (count01 == 2'b10);
    wire [1:0] sum = count01 + count2;

    // Final output
    assign out = sum;

endmodule