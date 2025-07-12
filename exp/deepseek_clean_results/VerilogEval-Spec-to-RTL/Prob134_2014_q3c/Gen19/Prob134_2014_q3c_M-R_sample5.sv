module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic using direct assignments
    wire [2:0] Y = 
        (~x & (y == 3'b000)) ? 3'b000 :
        ( x & (y == 3'b000)) ? 3'b001 :
        (~x & (y == 3'b001)) ? 3'b001 :
        ( x & (y == 3'b001)) ? 3'b100 :
        (~x & (y == 3'b010)) ? 3'b010 :
        ( x & (y == 3'b010)) ? 3'b001 :
        (~x & (y == 3'b011)) ? 3'b001 :
        ( x & (y == 3'b011)) ? 3'b010 :
        (~x & (y == 3'b100)) ? 3'b011 :
        ( x & (y == 3'b100)) ? 3'b100 :
        3'b000;  // Default case (should never occur)

    // Output logic
    assign z = 
        (~x & (y == 3'b011)) ? 1'b1 :
        ( x & (y == 3'b011)) ? 1'b1 :
        (~x & (y == 3'b100)) ? 1'b1 :
        ( x & (y == 3'b100)) ? 1'b1 :
        1'b0;  // Default case

    assign Y0 = Y[0];

endmodule