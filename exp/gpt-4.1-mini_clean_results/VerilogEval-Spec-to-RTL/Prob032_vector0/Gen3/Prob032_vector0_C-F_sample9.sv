module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Local wires for split bits improve readability and modularity
    wire bit0, bit1, bit2;

    // Assign individual bits from vec
    assign bit0 = vec[0];
    assign bit1 = vec[1];
    assign bit2 = vec[2];

    // Output each bit explicitly
    assign o0 = bit0;
    assign o1 = bit1;
    assign o2 = bit2;

    // Reconstruct outv from individual bits for clarity of data flow
    assign outv = {bit2, bit1, bit0};

endmodule