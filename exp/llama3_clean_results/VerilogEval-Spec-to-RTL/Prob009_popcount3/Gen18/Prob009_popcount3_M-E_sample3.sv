module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // First level: Count '1's in pairs
    wire [1:0] count_01; // Count of '1's in in[0] and in[1]
    assign count_01 = in[0] + in[1];

    // Second level: Sum up counts from each pair and the lone bit
    assign out = count_01 + in[2];

endmodule