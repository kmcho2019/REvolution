module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Direct bit slicing for each output bit
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    // Compose outv by concatenating the individual bits
    assign outv = {o2, o1, o0};

endmodule