module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    case (1'b1)
        in[3]: pos = 2'b10;  // Position 4
        in[2]: pos = 2'b01;  // Position 2
        in[1]: pos = 2'b01;  // Position 2
        in[0]: pos = 2'b01;  // Position 1
        default: pos = 2'b00;  // No '1' bits
    endcase
end

endmodule