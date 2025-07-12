module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Calculate the population count using simple combinational logic
    wire [1:0] count;
    assign count = in[0] + in[1] + in[2];

    // Output the count as a 2-bit binary number
    assign out = count[1:0];

endmodule