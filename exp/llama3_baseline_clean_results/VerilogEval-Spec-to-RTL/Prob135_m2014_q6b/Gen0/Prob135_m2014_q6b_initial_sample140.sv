module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// next-state logic for y[1]
wire next_y1;
assign next_y1 = (y == 3'b000 && w) || 
                 (y == 3'b100 && (w || ~w)) || 
                 (y == 3'b101 && (w || ~w)) || 
                 (y == 3'b110 && w);

endmodule