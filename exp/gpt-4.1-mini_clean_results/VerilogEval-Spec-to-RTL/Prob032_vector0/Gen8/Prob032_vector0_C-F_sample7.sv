module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Internal wires for bit splitting, enhancing readability without module overhead
    wire bit0 = vec[0];
    wire bit1 = vec[1];
    wire bit2 = vec[2];

    // Output the vector directly from input
    assign outv = vec;

    // Assign individual outputs from internal wires for clarity
    assign o0 = bit0;
    assign o1 = bit1;
    assign o2 = bit2;

endmodule