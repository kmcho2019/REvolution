module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Parallel prefix computation for higher priority bits
wire [7:0] higher_prio_set;
assign higher_prio_set[0] = 1'b0;
assign higher_prio_set[1] = in[0];
assign higher_prio_set[2] = |in[1:0];
assign higher_prio_set[3] = |in[2:0];
assign higher_prio_set[4] = |in[3:0];
assign higher_prio_set[5] = |in[4:0];
assign higher_prio_set[6] = |in[5:0];
assign higher_prio_set[7] = |in[6:0];

// Isolate first set bit
wire [7:0] first_set = in & ~higher_prio_set;

// Logarithmic position encoder
assign pos[2] = |first_set[7:4];
assign pos[1] = |first_set[7:6] | |first_set[3:2];
assign pos[0] = |first_set[7:6:4:5] | |first_set[3:2:0:1];

endmodule