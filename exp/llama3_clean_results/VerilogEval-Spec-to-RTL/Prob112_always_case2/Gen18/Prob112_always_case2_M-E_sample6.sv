module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11; // Position 4
        4'b0100: pos = 2'b10; // Position 3
        4'b0010: pos = 2'b01; // Position 2
        4'b0001: pos = 2'b00; // Position 1
        default: pos = 2'b00;  // No '1' bits, output 0
    endcase
end

endmodule