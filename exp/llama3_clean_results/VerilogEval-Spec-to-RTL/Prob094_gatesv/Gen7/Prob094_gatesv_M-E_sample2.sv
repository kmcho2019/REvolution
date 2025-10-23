module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Calculate out_both by shifting the input vector to the right and performing a bitwise AND operation
    assign out_both = (in << 1) & in;

    // Calculate out_any by shifting the input vector to the left and performing a bitwise OR operation
    assign out_any = in | (in >> 1);

    // Calculate out_different by shifting the input vector to the right and performing a bitwise XOR operation
    // To handle the wrap-around for the most significant bit, we use a combination of shift and concatenation
    assign out_different = in ^ ({in[0], in[3:1]});

endmodule