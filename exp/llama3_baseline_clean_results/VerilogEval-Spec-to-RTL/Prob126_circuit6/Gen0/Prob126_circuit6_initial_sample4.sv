module TopModule(
    input [2:0] a,
    output [15:0] q
);

always @(*)
begin
    case(a)
        3'b000: q = 16'h1232; // For a = 0, q = 1232 (hex)
        3'b001: q = 16'haee0; // For a = 1, q = aee0 (hex)
        3'b010: q = 16'h27d4; // For a = 2, q = 27d4 (hex)
        3'b011: q = 16'h5a0e; // For a = 3, q = 5a0e (hex)
        3'b100: q = 16'h2066; // For a = 4, q = 2066 (hex)
        3'b101: q = 16'h64ce; // For a = 5, q = 64ce (hex)
        3'b110: q = 16'hc526; // For a = 6, q = c526 (hex)
        3'b111: q = 16'h2f19; // For a = 7, q = 2f19 (hex)
        default: q = 16'hxxxx; // Default value for invalid inputs
    endcase
end

endmodule