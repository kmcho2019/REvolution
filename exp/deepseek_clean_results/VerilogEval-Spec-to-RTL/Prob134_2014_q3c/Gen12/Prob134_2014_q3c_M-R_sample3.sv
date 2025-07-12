module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic
    wire [2:0] Y;
    assign {Y, z} = 
        (y == 3'b000) ? (x ? {3'b001, 1'b0} : {3'b000, 1'b0}) :
        (y == 3'b001) ? (x ? {3'b100, 1'b0} : {3'b001, 1'b0}) :
        (y == 3'b010) ? (x ? {3'b001, 1'b0} : {3'b010, 1'b0}) :
        (y == 3'b011) ? (x ? {3'b010, 1'b1} : {3'b001, 1'b1}) :
        (y == 3'b100) ? (x ? {3'b100, 1'b1} : {3'b011, 1'b1}) :
                        {3'b000, 1'b0};  // Default case (should never occur)

    assign Y0 = Y[0];

endmodule