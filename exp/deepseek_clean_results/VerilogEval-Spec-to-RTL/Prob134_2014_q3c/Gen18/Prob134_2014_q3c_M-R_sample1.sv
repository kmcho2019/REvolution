module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    wire [2:0] Y;
    wire z_out;

    // Next state logic
    assign Y = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
               (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
               (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
               (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
               /* y == 3'b100 */ (x ? 3'b100 : 3'b011);

    // Output logic
    assign z_out = (y == 3'b011) ? 1'b1 :
                   (y == 3'b100) ? 1'b1 :
                   1'b0;

    assign z = z_out;
    assign Y0 = Y[0];

endmodule