module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

reg [1:0] addr;
reg [0:0] lut_out;

always @(*) begin
    addr = {A, B}; // Form the address by concatenating A and B
    case(addr)
        4'b0000: lut_out = 1'b1; // A=00, B=00
        4'b0001: lut_out = 1'b0; // A=00, B=01
        4'b0010: lut_out = 1'b0; // A=00, B=10
        4'b0011: lut_out = 1'b0; // A=00, B=11
        4'b0100: lut_out = 1'b0; // A=01, B=00
        4'b0101: lut_out = 1'b1; // A=01, B=01
        4'b0110: lut_out = 1'b0; // A=01, B=10
        4'b0111: lut_out = 1'b0; // A=01, B=11
        4'b1000: lut_out = 1'b0; // A=10, B=00
        4'b1001: lut_out = 1'b0; // A=10, B=01
        4'b1010: lut_out = 1'b1; // A=10, B=10
        4'b1011: lut_out = 1'b0; // A=10, B=11
        4'b1100: lut_out = 1'b0; // A=11, B=00
        4'b1101: lut_out = 1'b0; // A=11, B=01
        4'b1110: lut_out = 1'b0; // A=11, B=10
        4'b1111: lut_out = 1'b1; // A=11, B=11
        default: lut_out = 1'b0; // Default case, should not occur
    endcase
    z = lut_out;
end

endmodule