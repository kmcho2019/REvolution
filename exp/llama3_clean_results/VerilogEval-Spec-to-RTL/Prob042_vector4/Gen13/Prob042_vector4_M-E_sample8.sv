module TopModule (
    input [7:0] in,
    output [31:0] out
);

    assign out = (in[7] == 1'b1)? ({24{1'b1}}, in) : ({24{1'b0}}, in);

    // Alternatively, we can use the following code to achieve the same result
    // wire [31:0] temp;
    // assign temp = {24{in[7]}};
    // assign out = (in[7] == 1'b1)? (temp | in) : temp;

    // Another way to do it
    // assign out = {24{in[7]}};
    // assign out[7:0] = in;

endmodule