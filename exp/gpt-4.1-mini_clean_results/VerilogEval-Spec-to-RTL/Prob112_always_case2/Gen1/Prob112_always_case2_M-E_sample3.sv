module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

// Determine if upper half has any set bits
wire upper_set = |in[3:2];

// Use upper_set as MSB of pos; the LSB depends on which bit is set within the chosen half
wire lower_bit0 = upper_set ? in[3] : in[1];

assign pos = {upper_set, lower_bit0};

endmodule