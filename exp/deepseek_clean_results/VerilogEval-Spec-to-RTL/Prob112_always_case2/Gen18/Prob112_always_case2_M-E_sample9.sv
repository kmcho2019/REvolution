module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Create priority mask - each bit is 1 only if no higher priority bit is set
wire [3:0] priority_mask = {
    in[3],
    ~in[3] & in[2],
    ~in[3] & ~in[2] & in[1],
    ~in[3] & ~in[2] & ~in[1] & in[0]
};

// Isolate the highest priority 1
wire [3:0] isolated_bit = in & priority_mask;

// Encode the position
assign pos[1] = isolated_bit[3] | isolated_bit[2];
assign pos[0] = isolated_bit[3] | isolated_bit[1];

endmodule