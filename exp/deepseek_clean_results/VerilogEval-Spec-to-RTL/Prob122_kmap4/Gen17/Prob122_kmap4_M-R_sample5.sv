module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    /* Implementation of K-map:
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    always @(*) begin
        case ({c,d,a,b})
            4'b0000: out = 0;
            4'b0001: out = 1;
            4'b0010: out = 0;
            4'b0011: out = 1;
            4'b0100: out = 1;
            4'b0101: out = 0;
            4'b0110: out = 1;
            4'b0111: out = 0;
            4'b1000: out = 0;
            4'b1001: out = 1;
            4'b1010: out = 0;
            4'b1011: out = 1;
            4'b1100: out = 1;
            4'b1101: out = 0;
            4'b1110: out = 1;
            4'b1111: out = 0;
        endcase
    end

endmodule