module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Decode individual states for clarity
    wire state_A = (y == 3'b000);
    wire state_B = (y == 3'b001);
    wire state_C = (y == 3'b010);
    wire state_D = (y == 3'b011);
    wire state_E = (y == 3'b100);
    wire state_F = (y == 3'b101);

    // next y[1] logic as per state machine conditions
    wire next_y1 = 
           state_B 
        | (state_C & w) 
        | (state_E & w) 
        | state_F;

    assign Y1 = next_y1;

endmodule