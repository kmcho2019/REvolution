module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation
    wire [2:0] Y = x ? 
        (y == 3'b000 ? 3'b001 :
         y == 3'b001 ? 3'b100 :
         y == 3'b010 ? 3'b001 :
         y == 3'b011 ? 3'b010 :
         y == 3'b100 ? 3'b100 : 3'b000) :
        (y == 3'b000 ? 3'b000 :
         y == 3'b001 ? 3'b001 :
         y == 3'b010 ? 3'b010 :
         y == 3'b011 ? 3'b001 :
         y == 3'b100 ? 3'b011 : 3'b000);

    // Output computation
    assign z = (y == 3'b011) || (y == 3'b100);

    // Y0 is LSB of next state
    assign Y0 = Y[0];

endmodule