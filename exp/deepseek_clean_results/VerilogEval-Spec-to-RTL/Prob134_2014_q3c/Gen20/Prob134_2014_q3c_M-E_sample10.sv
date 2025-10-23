module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // One-hot state encoding
    wire s000 = (y == 3'b000);
    wire s001 = (y == 3'b001);
    wire s010 = (y == 3'b010);
    wire s011 = (y == 3'b011);
    wire s100 = (y == 3'b100);

    // Next state bit 0 (Y0)
    assign Y0 = (s000 & x) | (s010 & x) | (s011 & ~x) | (s100 & ~x);

    // Output z logic
    assign z = (s011 | s100);

endmodule