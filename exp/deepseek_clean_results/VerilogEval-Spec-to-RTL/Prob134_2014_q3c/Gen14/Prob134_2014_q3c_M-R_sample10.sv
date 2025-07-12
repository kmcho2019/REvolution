module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state and output logic
    wire [3:0] next_state_z;
    assign next_state_z = 
        (y == 3'b000) ? (x ? {3'b001, 1'b0} : {3'b000, 1'b0}) :
        (y == 3'b001) ? (x ? {3'b100, 1'b0} : {3'b001, 1'b0}) :
        (y == 3'b010) ? (x ? {3'b001, 1'b0} : {3'b010, 1'b0}) :
        (y == 3'b011) ? (x ? {3'b010, 1'b1} : {3'b001, 1'b1}) :
        (y == 3'b100) ? (x ? {3'b100, 1'b1} : {3'b011, 1'b1}) :
        {3'b000, 1'b0};  // Default case (should never occur)

    assign Y0 = next_state_z[3];  // Y[0] is bit 3 of the 4-bit output (next_state_z[3:1] = Y[2:0])
    assign z = next_state_z[0];

endmodule