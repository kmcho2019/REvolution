module TopModule (
    input [7:0] in,
    output [31:0] out
);

    wire sign_bit;
    wire [31:0] mask;
    wire [31:0] shifted_in;

    // Extract the sign bit of the input number
    assign sign_bit = in[7];

    // Create a mask with all bits set to the sign bit value
    assign mask = sign_bit? 32'hFFFFFFFF : 32'h00000000;

    // Shift the input number to its correct position
    assign shifted_in = {24'b0, in};

    // Sign-extend the input number using bitwise OR operation with the mask
    assign out = mask & shifted_in;

endmodule