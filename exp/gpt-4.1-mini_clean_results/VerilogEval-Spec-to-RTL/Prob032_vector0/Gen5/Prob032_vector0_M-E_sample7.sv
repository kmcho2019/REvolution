module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign each bit of vec to corresponding outputs
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    // Concatenate outputs in reverse order to form outv (o0 as MSB)
    assign outv = {o0, o1, o2};

endmodule