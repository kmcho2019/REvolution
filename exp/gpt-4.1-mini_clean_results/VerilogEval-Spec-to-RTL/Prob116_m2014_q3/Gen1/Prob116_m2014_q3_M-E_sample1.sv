module TopModule (
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output reg f
);
    /*
    According to the problem:
    Inputs: x = x[3], x[2], x[1], x[0]

    Karnaugh map indices:
      Rows = x[3] x[4] (but x[4] doesn't exist, assume typo, likely x[0])
      Columns = x[1] x[2]

    Given Karnaugh map: 
                  x[1]x[2]
      x[3]x[4]   00  01  11  10
            00 | d | 0 | d | d |
            01 | 0 | d | 1 | 0 |
            11 | 1 | 1 | d | d |
            10 | 1 | 1 | 0 | d |

    Assume rows = x[3] x[0], columns = x[1] x[2] (since only x[0] and x[3] left)
    
    So we consider input as:
        Row bits = x[3], x[0]
        Column bits = x[1], x[2]

    Map each cell (row, col) to input x:

    We'll write out all 16 combinations of x[3:0]:

    x[3] x[2] x[1] x[0]  f (from Karnaugh)
    ---------------------------------------
    0    0    0    0     d -> choose 0
    0    0    0    1     0
    0    0    1    0     d -> 0
    0    0    1    1     d -> 0

    0    1    0    0     0
    0    1    0    1     d -> 0
    0    1    1    0     1
    0    1    1    1     0

    1    1    0    0     1
    1    1    0    1     1
    1    1    1    0     0
    1    1    1    1     d -> 0

    1    0    0    0     1
    1    0    0    1     1
    1    0    1    0     0
    1    0    1    1     d -> 0

    Mark minterms where output is 1 explicitly:

    Inputs for f=1:
    - x=4'b0110  (0 1 1 0)
    - x=4'b1100  (1 1 0 0)
    - x=4'b1101  (1 1 0 1)
    - x=4'b1000  (1 0 0 0)
    - x=4'b1001  (1 0 0 1)
    - x=4'b0100  (0 1 0 0)
    - x=4'b0101  (0 1 0 1) is d → 0 (so not included)
    - x=4'b0111  (0 1 1 1) = 0
    - x=4'b1110  (1 1 1 0) = 0
    - x=4'b1111  (1 1 1 1) = d → 0
    - x=4'b0011  (0 0 1 1) = d → 0
    - x=4'b0000  (0 0 0 0) = d → 0
    - x=4'b0001  (0 0 0 1) = 0
    - x=4'b0010  (0 0 1 0) = d →0

    Only the above minterms with 1:

    0110 (0x1 1 0)  -> 0,1,1,0 = 4'b0110
    1100 -> 4'b1100
    1101 -> 4'b1101
    1000 -> 4'b1000
    1001 -> 4'b1001

    Also in row 11 col 01 is 1 (x=11 01): row bits x[3]x[0]=11, col x[1]x[2]=01 -> x[3]=1,x[0]=1,x[1]=0,x[2]=1 (4'b1011) which is not included above, but the table says 1 in that cell

    Check that: row 11 col 01 => x[3]=1, x[0]=1, x[1]=0, x[2]=1 => x=4'b1011 => f=1 (confirmed)

    So add 4'b1011 to the list.

    Also row 11 col 00 = 1 => x[3]=1,x[0]=1,x[1]=0,x[2]=0 => 1101 → already included.

    row 10 col 00 = 1 => x[3]=1, x[0]=0, x[1]=0,x[2]=0 => 1000 already included.

    row 10 col 01 =1 => 1 0 0 1 -> 1001 already included.

    row 01 col 11 = 1 => row 01 = x[3]x[0]=0 1, col 11 = x[1]x[2]=1 1 => x= 0 1 1 1 = 0111, but the table says 0 there.

    So 0111 = 0

    So complete list f=1 inputs:

    0110 (0x1 1 0)
    1100 (1 1 0 0)
    1101 (1 1 0 1)
    1000 (1 0 0 0)
    1001 (1 0 0 1)
    1011 (1 0 1 1)

    Implement these minterms directly.

    */
    always @(*) begin
        case (x)
            4'b0110: f = 1;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1011: f = 1;
            default: f = 0;
        endcase
    end
endmodule