module TopModule(
    input  [2:0] vec,
    output wire [2:0] outv,
    output wire       o2,
    output wire       o1,
    output wire       o0
);

// Pass input vector directly to the 3-bit output vector
assign outv = vec;

// Split the input vector bits directly to single-bit outputs
assign {o2, o1, o0} = vec;

endmodule