module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Use the reduction operator to count set bits in 'in'
    assign out = in[0] + in[1] + in[2]; // direct addition (clear and minimal)

    // Alternative (commented): assign out = $unsigned(in[0]) + $unsigned(in[1]) + $unsigned(in[2]);

    // Or slightly more concise using reduction operator + count:
    // assign out = in[0] + in[1] + in[2]; // Most synthesis tools optimize similarly.

endmodule