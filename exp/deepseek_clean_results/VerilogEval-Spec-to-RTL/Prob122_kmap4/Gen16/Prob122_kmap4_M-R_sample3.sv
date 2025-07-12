module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation of K-map (checkerboard pattern):
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    wire [3:0] inputs = {a, b, c, d};
    
    always @(*) begin
        case (inputs)
            4'b0000, 4'b0011, 4'b0110, 4'b0101, 4'b1001, 4'b1010, 4'b1100, 4'b1111: out = 0;
            4'b0001, 4'b0010, 4'b0100, 4'b0111, 4'b1000, 4'b1011, 4'b1101, 4'b1110: out = 1;
            default: out = 1'bx; // should never occur
        endcase
    end

endmodule