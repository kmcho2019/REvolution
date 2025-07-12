module TopModule(
    input [5:0] y, 
    input w, 
    output Y1, 
    output Y3
);

// Y1 is high when the current state is B
assign Y1 = (y[5:0] == 6'b000010) ? 1'b1 : 
            (y[5:0] == 6'b000001 && ~w) ? 1'b1 :  // A and w=0
            (y[5:0] == 6'b100000 && w) ? 1'b1 :  // F and w=1
            1'b0;

// Y3 is high when the current state is D
assign Y3 = (y[5:0] == 6'b001000) ? 1'b1 : 
            (y[5:0] == 6'b000010 && ~w) ? 1'b1 :  // B and w=0
            (y[5:0] == 6'b000100 && ~w) ? 1'b1 :  // C and w=0
            (y[5:0] == 6'b010000 && ~w) ? 1'b1 :  // E and w=0
            (y[5:0] == 6'b100000 && ~w) ? 1'b1 :  // F and w=0
            1'b0;

endmodule