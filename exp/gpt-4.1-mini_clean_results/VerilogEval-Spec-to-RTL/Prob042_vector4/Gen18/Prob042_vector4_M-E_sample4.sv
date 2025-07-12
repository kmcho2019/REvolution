module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire signed [31:0] extended_in = { {24{in[7]}}, in };
    // Perform arithmetic right shift by zero bits (no change) to emphasize signed extension
    wire signed [31:0] shifted = extended_in >>> 0;

    assign out = shifted;
endmodule