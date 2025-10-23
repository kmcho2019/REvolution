module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output computation using binary decision tree
    wire [2:0] Y = 
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :  // State 000
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :  // State 001
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :  // State 010
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :  // State 011
        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :  // State 100
                        3'b000;                  // Default case

    // Output computation using same decision tree structure
    assign z = 
        (y == 3'b000) ? 1'b0 :
        (y == 3'b001) ? 1'b0 :
        (y == 3'b010) ? 1'b0 :
        (y == 3'b011) ? 1'b1 :
        (y == 3'b100) ? 1'b1 :
                        1'b0;

    assign Y0 = Y[0];

endmodule