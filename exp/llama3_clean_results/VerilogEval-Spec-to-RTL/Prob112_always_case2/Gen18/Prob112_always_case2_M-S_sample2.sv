module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

reg [1:0] pos_reg;

always @(*)
begin
    pos_reg = 2'b00;  // Default output

    if (in[3]) pos_reg = 2'b11;  // Check most significant bit first
    else if (in[2]) pos_reg = 2'b10;
    else if (in[1]) pos_reg = 2'b01;
    else if (in[0]) pos_reg = 2'b00;
end

assign pos = pos_reg;

endmodule