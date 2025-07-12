module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

// State decoding
wire is_A = (y == 3'b000);
wire is_B = (y == 3'b001);
wire is_C = (y == 3'b010);
wire is_D = (y == 3'b011);
wire is_E = (y == 3'b100);
wire is_F = (y == 3'b101);

// y[1] next state logic
wire y1_next;
assign y1_next = 
    // Transitions where y[1] becomes 1
    (is_B & ~w) |       // B→C
    (is_C & w)  |       // C→D
    (is_E & w)  |       // E→D
    (is_F & ~w) |       // F→C
    
    // Maintain y[1] when no transition changes it
    (y[1] & ~(
        (is_A & ~w) |   // A→B
        (is_B & w)  |   // B→D
        (is_C & ~w) |   // C→E
        (is_D & w)  |   // D→A
        (is_D & ~w) |   // D→F
        (is_F & w)      // F→D
    ));

endmodule