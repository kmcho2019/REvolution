module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ({c,d,a,b} === 4'b0000) |  // cd=00, ab=00
             ({c,d,a,b} === 4'b0001) |  // cd=00, ab=01
             ({c,d,a,b} === 4'b0010) |  // cd=00, ab=10
             ({c,d,a,b} === 4'b0100) |  // cd=01, ab=00
             ({c,d,a,b} === 4'b0110) |  // cd=01, ab=10
             ({c,d,a,b} === 4'b1001) |  // cd=10, ab=01
             ({c,d,a,b} === 4'b1101) |  // cd=11, ab=01
             ({c,d,a,b} === 4'b1111) |  // cd=11, ab=11
             ({c,d,a,b} === 4'b1110) |  // cd=11, ab=10
             ({c,d,a,b} === 4'b1000);   // cd=10, ab=00

endmodule