module TopModule (
    input  [2:0] a,
    output [15:0] q
);

always @(*) begin
    case (a)
        3'b000: q = 16'h1232; // For a = 0
        3'b001: q = 16'haee0; // For a = 1
        3'b010: q = 16'h27d4; // For a = 2
        3'b011: q = 16'h5a0e; // For a = 3
        3'b100: q = 16'h2066; // For a = 4
        3'b101: q = 16'h64ce; // For a = 5
        3'b110: q = 16'hc526; // For a = 6
        3'b111: q = 16'h2f19; // For a = 7
        default: q = 16'hxxxx; // Default value if a is not in the specified range
    endcase
end

endmodule