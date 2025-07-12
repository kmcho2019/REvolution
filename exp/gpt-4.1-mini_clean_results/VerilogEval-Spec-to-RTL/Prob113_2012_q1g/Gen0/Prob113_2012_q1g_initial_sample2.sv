module TopModule (
    input  [3:0] x,
    output      f
);

    // 16-bit truth table representing the function f for each x
    // Index: x[3:0], Value: f
    // Bit 0 corresponds to x=0000, bit 15 to x=1111
    wire [15:0] truth_table = 16'b1110011110000001;

    assign f = truth_table[x];

endmodule