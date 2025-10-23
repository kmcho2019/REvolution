module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Direct computation of next state for y[1]
    assign Y1 = (
        // State A (000) transitions
        (y == 3'b000 && ~w) ? 1'b0 : 
        (y == 3'b000 && w) ? 1'b0 :
        
        // State B (001) transitions
        (y == 3'b001 && ~w) ? 1'b1 : 
        (y == 3'b001 && w) ? 1'b1 :
        
        // State C (010) transitions
        (y == 3'b010 && ~w) ? 1'b1 : 
        (y == 3'b010 && w) ? 1'b1 :
        
        // State D (011) transitions
        (y == 3'b011 && ~w) ? 1'b1 : 
        (y == 3'b011 && w) ? 1'b0 :
        
        // State E (100) transitions
        (y == 3'b100 && ~w) ? 1'b1 : 
        (y == 3'b100 && w) ? 1'b1 :
        
        // State F (101) transitions
        (y == 3'b101 && ~w) ? 1'b0 : 
        (y == 3'b101 && w) ? 1'b1 : 1'b0
    );

endmodule