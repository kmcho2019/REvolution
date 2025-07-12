module TopModule(
    input  [15:0] in,
    output [7:0] out_upper,
    output [7:0] out_lower
);

    assign out_upper = in[15:8];  // Assign upper 8 bits of input to out_upper
    assign out_lower = in[7:0];   // Assign lower 8 bits of input to out_lower

endmodule