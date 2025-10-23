module TopModule(
    input [2:0] y, // current state
    input w,       // input
    output Y1       // output, next state y[1]
);

// Next state logic for y[1]
assign Y1 = (y == 3'b000 && w) || 
            (y == 3'b001 && w) || 
            (y == 3'b011 && ~w) || 
            (y == 3'b100 && ~w) || 
            (y == 3'b101 && ~w) || 
            (y == 3'b110 && w) || 
            (y == 3'b111 && w);

endmodule