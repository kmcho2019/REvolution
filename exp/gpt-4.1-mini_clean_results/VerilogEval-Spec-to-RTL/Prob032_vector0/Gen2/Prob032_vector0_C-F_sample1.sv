module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Directly assign outv as the full vector input
assign outv = vec;

// Grouped continuous assignments for individual bits
assign o0 = vec[0];
assign o1 = vec[1];
assign o2 = vec[2];

endmodule