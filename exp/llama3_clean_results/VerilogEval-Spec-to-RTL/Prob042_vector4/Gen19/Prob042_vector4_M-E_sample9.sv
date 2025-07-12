module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Determine the sign bit of the input
    wire sign_bit = in[7];

    // Create a mask for sign extension: all ones if sign_bit is 1, all zeros if sign_bit is 0
    wire [31:0] mask = {24{sign_bit}};

    // Sign-extend the input
    assign out = (in[7] ? ({24{1'b1}} | (in << 24)) : (in << 24));

endmodule