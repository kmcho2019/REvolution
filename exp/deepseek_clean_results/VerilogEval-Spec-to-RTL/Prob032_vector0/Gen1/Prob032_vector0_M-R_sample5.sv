module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct connection for the vector output
    assign outv = vec;

    // Alternative approach using bit extraction
    wire [2:0] vec_bits;
    assign vec_bits = vec;  // This creates an explicit copy

    // Assign individual outputs from the unpacked bits
    assign {o2, o1, o0} = vec_bits;

endmodule