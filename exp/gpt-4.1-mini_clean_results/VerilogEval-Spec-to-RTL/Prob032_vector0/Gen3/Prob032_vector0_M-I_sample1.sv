module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Direct assignment of outv to input vec
assign outv = vec;

// Concatenate bits of vec into a vector and then assign individual outputs
wire [2:0] bits = vec;

assign {o2, o1, o0} = bits;

endmodule