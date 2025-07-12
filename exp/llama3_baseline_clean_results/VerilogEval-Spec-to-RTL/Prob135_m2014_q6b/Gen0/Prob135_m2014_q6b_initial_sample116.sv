module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next state logic for y[1]
wire y1_next;

assign y1_next = (y == 3'b100) ? 1'b1 : 
                 (y == 3'b101) ? 1'b1 : 
                 (y == 3'b110) ? 1'b1 : 
                 (y == 3'b111) ? 1'b1 : 
                 (y == 3'b000 && w) ? 1'b0 :
                 (y == 3'b001 && w) ? 1'b0 :
                 (y == 3'b001 && ~w) ? 1'b0 :
                 (y == 3'b010 && w) ? 1'b1 :
                 (y == 3'b010 && ~w) ? 1'b1 :
                 (y == 3'b011 && w) ? 1'b0 :
                 (y == 3'b011 && ~w) ? 1'b0 : 
                 1'b0;

assign Y1 = y[1];

endmodule