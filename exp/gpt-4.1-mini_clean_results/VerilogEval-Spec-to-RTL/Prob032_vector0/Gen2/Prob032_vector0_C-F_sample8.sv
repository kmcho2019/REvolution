module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Explicitly assign output bits from vec for clarity
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    // Assign outv directly from vec (or {o2,o1,o0} equivalently)
    assign outv = vec;

endmodule