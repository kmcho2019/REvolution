module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Explicitly replicate the sign bit 24 times and concatenate with input
    // Cast the entire concatenation to signed to emphasize sign extension intent
    assign out = $signed({ {24{in[7]}}, in });

endmodule