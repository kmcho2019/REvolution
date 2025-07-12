module TopModule(
    input [2:0] a,
    output reg [15:0] q
);

always @(*) begin
    case(a)
        3'b000: q = 16'h1232; // hex value for input a = 0
        3'b001: q = 16'haee0; // hex value for input a = 1
        3'b010: q = 16'h27d4; // hex value for input a = 2
        3'b011: q = 16'h5a0e; // hex value for input a = 3
        3'b100: q = 16'h2066; // hex value for input a = 4
        3'b101: q = 16'h64ce; // hex value for input a = 5
        3'b110: q = 16'hc526; // hex value for input a = 6
        3'b111: q = 16'h2f19; // hex value for input a = 7
        default: q = 16'hxxxx; // default value for invalid inputs
    endcase
end

endmodule