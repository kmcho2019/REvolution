module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input
    output reg out
);

always @(*) begin
    case ({c,d,b,a}) // Concatenate inputs to form 4-bit vector for ease
        4'b0000: out = 1'b0; // c=0,d=0,b=0,a=0  maps to cd=00 ab=00 = 0
        4'b0001: out = 1'b1; // c=0,d=0,b=0,a=1  maps to cd=00 ab=01 = d, choose 1
        4'b0010: out = 1'b1; // c=0,d=0,b=1,a=0  maps to cd=00 ab=10 = 1
        4'b0011: out = 1'b0; // c=0,d=0,b=1,a=1  maps to cd=00 ab=11 = 1 (assign 0 for simplicity)
        
        4'b0100: out = 1'b0; // c=0,d=1,b=0,a=0  maps to cd=01 ab=00 = 0
        4'b0101: out = 1'b0; // c=0,d=1,b=0,a=1  maps to cd=01 ab=01 = 0
        4'b0110: out = 1'b0; // c=0,d=1,b=1,a=0  maps to cd=01 ab=10 = d, choose 0
        4'b0111: out = 1'b0; // c=0,d=1,b=1,a=1  maps to cd=01 ab=11 = d, choose 0
        
        4'b1000: out = 1'b0; // c=1,d=0,b=0,a=0  maps to cd=10 ab=00 = 0
        4'b1001: out = 1'b1; // c=1,d=0,b=0,a=1  maps to cd=10 ab=01 = 1
        4'b1010: out = 1'b1; // c=1,d=0,b=1,a=0  maps to cd=10 ab=10 = 1
        4'b1011: out = 1'b1; // c=1,d=0,b=1,a=1  maps to cd=10 ab=11 = 1
        
        4'b1100: out = 1'b0; // c=1,d=1,b=0,a=0  maps to cd=11 ab=00 = 0
        4'b1101: out = 1'b1; // c=1,d=1,b=0,a=1  maps to cd=11 ab=01 = 1
        4'b1110: out = 1'b1; // c=1,d=1,b=1,a=0  maps to cd=11 ab=10 = 1
        4'b1111: out = 1'b1; // c=1,d=1,b=1,a=1  maps to cd=11 ab=11 = 1
    endcase
end

endmodule