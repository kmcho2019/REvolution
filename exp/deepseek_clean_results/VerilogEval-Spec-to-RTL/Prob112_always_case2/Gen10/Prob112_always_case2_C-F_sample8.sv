module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    case (in & -in)  // Isolate rightmost 1-bit
        4'b0000: pos = 2'b00;  // All zeros case first
        4'b0001: pos = 2'b00;
        4'b0010: pos = 2'b01;
        4'b0100: pos = 2'b10;
        4'b1000: pos = 2'b11;
    endcase
end

endmodule