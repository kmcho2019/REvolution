module TopModule (
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casex (in)
        4'b1xxx: pos = 2'b11; // First '1' is in[3]
        4'b01xx: pos = 2'b10; // First '1' is in[2]
        4'b001x: pos = 2'b01; // First '1' is in[1]
        4'b0001: pos = 2'b00; // First '1' is in[0]
        default: pos = 2'b00; // No '1' found
    endcase
end

endmodule