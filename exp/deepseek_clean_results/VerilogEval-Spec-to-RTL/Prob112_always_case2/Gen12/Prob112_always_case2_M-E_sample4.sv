module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire lower_nonzero = |in[1:0];
wire upper_nonzero = |in[3:2];

// Lower bits priority
wire pos0 = in[0];
wire pos1 = ~in[0] & in[1];

// Upper bits priority (only checked if lower bits are zero)
wire pos2 = ~lower_nonzero & in[2];
wire pos3 = ~lower_nonzero & ~in[2] & in[3];

assign pos[0] = pos0 | pos2;
assign pos[1] = pos1 | pos3;

endmodule