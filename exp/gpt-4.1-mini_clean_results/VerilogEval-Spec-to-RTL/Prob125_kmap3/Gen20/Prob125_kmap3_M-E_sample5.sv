module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output reg out
);

always @(*) begin
    case ({c,d,b,a}) // combining inputs to match cd/ab Karnaugh layout: c d b a
        4'b0000: out = 1'b0; // cd=00, ab=00, output=0
        4'b0001: out = 1'b1; // cd=00, ab=01, output=1
        4'b0010: out = 1'b1; // cd=00, ab=10, output=1
        4'b0011: out = 1'b0; // cd=00, ab=11, output=0 (chosen d=0 for don't-care)
        
        4'b0100: out = 1'b0; // cd=01, ab=00, output=0
        4'b0101: out = 1'b0; // cd=01, ab=01, output=0
        4'b0110: out = 1'b0; // cd=01, ab=10, output=0 (d don't care chosen as 0)
        4'b0111: out = 1'b0; // cd=01, ab=11, output=0 (d don't care chosen as 0)
        
        4'b1000: out = 1'b0; // cd=10, ab=00, output=0
        4'b1001: out = 1'b1; // cd=10, ab=01, output=1
        4'b1010: out = 1'b1; // cd=10, ab=10, output=1
        4'b1011: out = 1'b1; // cd=10, ab=11, output=1
        
        4'b1100: out = 1'b0; // cd=11, ab=00, output=0
        4'b1101: out = 1'b1; // cd=11, ab=01, output=1
        4'b1110: out = 1'b1; // cd=11, ab=10, output=1
        4'b1111: out = 1'b1; // cd=11, ab=11, output=1
        
        default: out = 1'b0; // fallback, though all cases covered
    endcase
end

endmodule