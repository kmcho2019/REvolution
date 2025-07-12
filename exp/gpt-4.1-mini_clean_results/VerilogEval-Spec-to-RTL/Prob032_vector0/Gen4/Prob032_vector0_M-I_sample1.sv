module TopModule(
    input  [2:0] vec,
    output wire [2:0] outv,
    output wire       o2,
    output wire       o1,
    output wire       o0
);

// Pass input vector directly to the 3-bit output vector
assign outv = vec;

// Explicitly assign each bit of the input vector to corresponding outputs
assign o0 = vec[0];
assign o1 = vec[1];
assign o2 = vec[2];

endmodule