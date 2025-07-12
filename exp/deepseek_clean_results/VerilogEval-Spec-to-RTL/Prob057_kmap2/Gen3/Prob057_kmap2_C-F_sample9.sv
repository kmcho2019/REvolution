module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    case ({c, d, a, b})
        // Cases where output is 0
        4'b0011,  // cd=00, ab=11
        4'b0101,  // cd=01, ab=01
        4'b0111,  // cd=01, ab=11
        4'b1011,  // cd=10, ab=11
        4'b1010,  // cd=10, ab=10
        4'b1100:  // cd=11, ab=00
            out = 0;
        // All other cases output 1
        default:
            out = 1;
    endcase
end

endmodule