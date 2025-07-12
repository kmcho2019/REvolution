module TopModule(
    input [2:0] a,
    output [15:0] q
);

reg [15:0] rom [7:0];

initial begin
    rom[0] = 16'h1232;
    rom[1] = 16'haee0;
    rom[2] = 16'h27d4;
    rom[3] = 16'h5a0e;
    rom[4] = 16'h2066;
    rom[5] = 16'h64ce;
    rom[6] = 16'hc526;
    rom[7] = 16'h2f19;
end

always @(*) begin
    case (a)
        3'b000: q = rom[0];
        3'b001: q = rom[1];
        3'b010: q = rom[2];
        3'b011: q = rom[3];
        3'b100: q = rom[4];
        3'b101: q = rom[5];
        3'b110: q = rom[6];
        3'b111: q = rom[7];
        default: q = 16'h0000;
    endcase
end

endmodule