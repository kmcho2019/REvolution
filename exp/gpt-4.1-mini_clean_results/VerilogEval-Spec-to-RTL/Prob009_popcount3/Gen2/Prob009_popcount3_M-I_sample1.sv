module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // Use bitwise reduction operator plus addition for clarity and minor synthesis optimization
    wire bit0 = in[0];
    wire bit1 = in[1];
    wire bit2 = in[2];

    assign out = bit0 + bit1 + bit2;
endmodule