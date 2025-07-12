module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode each state into a one-hot signal (A-F)
    wire A = (y == 3'b000);
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    // Compute next_y1 based on FSM transitions for y[1]
    // Next y[1] is 1 for states B, (C & w), (E & w), or F
    wire next_y1 = B | (C & w) | (E & w) | F;

    assign Y1 = next_y1;

endmodule