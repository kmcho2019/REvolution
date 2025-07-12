module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

wire y1_next;

assign Y1 = y[1];

// Next-state logic for y[1]
assign y1_next = (y == 3'b001 && w) || (y == 3'b010 && w) || 
                 (y == 3'b011 && w) || (y == 3'b100) || 
                 (y == 3'b101 && w);

endmodule