module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic combined
    assign Y0 = (y == 3'b000) ? (x ? 1'b1 : 1'b0) :
                (y == 3'b001) ? (x ? 1'b0 : 1'b1) :
                (y == 3'b010) ? (x ? 1'b1 : 1'b0) :
                (y == 3'b011) ? (x ? 1'b0 : 1'b1) :
                                (x ? 1'b0 : 1'b1); // y == 3'b100
    
    assign z = (y[2] & ~y[1]) | (y[2] & ~y[0]); // States 011 (3'b011) and 100 (3'b100)

endmodule