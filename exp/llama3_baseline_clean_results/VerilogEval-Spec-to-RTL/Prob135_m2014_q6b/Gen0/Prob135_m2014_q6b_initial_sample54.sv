module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

wire y1_next;

assign y1_next = (y[0] & w) | (y[1] & ~y[0]) | (y[2] & w) | (~y[0] & y[2] & ~w);
assign Y1 = y[1];

endmodule