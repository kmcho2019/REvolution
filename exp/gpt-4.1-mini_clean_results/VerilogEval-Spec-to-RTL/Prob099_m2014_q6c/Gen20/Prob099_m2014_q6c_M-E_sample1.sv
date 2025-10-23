module TopModule(
    input  [5:0] y,   // current state one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    wire [5:0] next_state;

    assign next_state =
        // From A (y[0])
        (y[0] & (w ? 6'b000001 : 6'b000010)) |  
        // From B (y[1])
        (y[1] & (w ? 6'b001000 : 6'b000100)) |  
        // From C (y[2])
        (y[2] & (w ? 6'b001000 : 6'b010000)) |  
        // From D (y[3])
        (y[3] & (w ? 6'b000001 : 6'b100000)) |  
        // From E (y[4])
        (y[4] & (w ? 6'b001000 : 6'b010000)) |  
        // From F (y[5])
        (y[5] & (w ? 6'b001000 : 6'b000100));    

    // Outputs are bits 1 and 3 of next_state
    assign Y1 = next_state[1];  // B
    assign Y3 = next_state[3];  // D

endmodule