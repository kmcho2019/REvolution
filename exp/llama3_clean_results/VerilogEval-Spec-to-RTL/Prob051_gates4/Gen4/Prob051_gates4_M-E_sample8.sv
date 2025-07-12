// Top-level module implementing the optimized gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Implement the 4-input AND gate
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // Implement the 4-input OR gate
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // Implement the 4-input XOR gate by counting the number of high inputs
    wire [1:0] count_high;
    assign count_high = (in[3] ? 1 : 0) + (in[2] ? 1 : 0) + (in[1] ? 1 : 0) + (in[0] ? 1 : 0);
    assign out_xor = count_high[0] ^ count_high[1];
endmodule