module TopModule(
    input  [2:0] vec,
    output wire [2:0] outv,
    output wire       o2,
    output wire       o1,
    output wire       o0
);

// Assign input vector directly to output vector
assign outv = vec;

// Derive individual bits from outv to possibly share output buffers
assign o0 = outv[0];
assign o1 = outv[1];
assign o2 = outv[2];

endmodule