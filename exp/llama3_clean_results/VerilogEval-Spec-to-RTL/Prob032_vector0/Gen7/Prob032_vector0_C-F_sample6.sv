module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Direct assignment for outv to ensure simplicity and efficiency
assign outv = vec;

// Individual assignments for o2, o1, and o0 to improve readability
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule