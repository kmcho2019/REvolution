module TopModule(
    input  [3:0] x,
    output reg f
);
    /*
    Given Karnaugh map with inputs x[3:0], interpreting bits as:
      x[3]: MSB
      x[0]: LSB

    Karnaugh map as a 4x4 table indexed by row = x[3:2], col = x[1:0]:
                      x[1]x[0]
        x[3]x[2]   00  01  11  10
              00 | d | 0 | d | d |
              01 | 0 | d | 1 | 0 |
              11 | 1 | 1 | d | d |
              10 | 1 | 1 | 0 | d |

    We'll assign 'd' = 0 for ROM entries for simplicity.

    Therefore the function f is defined by the following truth table (x -> f):

    Row(x[3:2]) Col(x[1:0])   x[3:0]   f
        00         00          4'b0000   d->0
        00         01          4'b0001   0
        00         11          4'b0011   d->0
        00         10          4'b0010   d->0

        01         00          4'b0100   0
        01         01          4'b0101   d->0
        01         11          4'b0111   1
        01         10          4'b0110   0

        11         00          4'b1100   1
        11         01          4'b1101   1
        11         11          4'b1111   d->0
        11         10          4'b1110   d->0

        10         00          4'b1000   1
        10         01          4'b1001   1
        10         11          4'b1011   0
        10         10          4'b1010   d->0

    We'll implement this as a combinational case statement.
    */

    always @(*) begin
        case (x)
            4'b0000: f = 1'b0; // d->0
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0; // d->0
            4'b0010: f = 1'b0; // d->0

            4'b0100: f = 1'b0;
            4'b0101: f = 1'b0; // d->0
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;

            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b0; // d->0
            4'b1110: f = 1'b0; // d->0

            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0;
            4'b1010: f = 1'b0; // d->0

            default: f = 1'b0; // fallback for safety
        endcase
    end

endmodule