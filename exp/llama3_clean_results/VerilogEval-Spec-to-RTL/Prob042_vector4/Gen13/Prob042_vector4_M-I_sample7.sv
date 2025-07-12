module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Directly construct the output using bitwise operations
    assign out = ({24{in[7]}} << 8) | in;

endmodule