module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire [1:0] sum;

    // Sum bits using bitwise addition
    // sum = number of set bits in 'in' (0 to 3)
    assign sum = in[0] + in[1] + in[2];

    // out[1] = 1 if sum >= 2
    assign out[1] = sum[1];

    // out[0] = parity of input bits (LSB of sum)
    assign out[0] = sum[0];

endmodule