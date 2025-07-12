module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire y1_next;
    assign y1_next = (y == 3'b000 && w) || 
                     (y == 3'b001 && w) || 
                     (y == 3'b100 && w) || 
                     (y == 3'b101 && w) || 
                     (y == 3'b100 && ~w) || 
                     (y == 3'b101 && ~w) || 
                     (y == 3'b011 && ~w) || 
                     (y == 3'b010 && ~w);

    // Output Y1 is y[1]
    assign Y1 = y[1];

endmodule