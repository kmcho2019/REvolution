module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, used in address, but output assigned as convenient
    output reg out
);

always @(*) begin
    // Combine cd and ab into a 4-bit vector:
    // cd are MSBs, ab are LSBs (as per given K-map ordering)
    // ab: a = LSB, b next, cd: c = LSB, d next
    // From problem statement, rows indexed by cd in order: 00,01,11,10
    // and columns by ab in order: 01,00,10,11 (so columns are in order: 01,00,10,11)
    // To align indexing, map inputs to index carefully:

    // Let's define indices for columns (ab):
    // column 0 -> ab=01
    // column 1 -> ab=00
    // column 2 -> ab=10
    // column 3 -> ab=11

    // Let's build column index from ab:
    // We'll define col = (a_bit * 2) + b_bit but reordered as per column order in K-map.
    // But since columns are in order: 01,00,10,11,
    // ab    col index
    // 0 1 -> 0
    // 0 0 -> 1
    // 1 0 -> 2
    // 1 1 -> 3

    // So column index can be computed as:
    // col = ({a,b} == 2'b01) ? 0 :
    //       ({a,b} == 2'b00) ? 1 :
    //       ({a,b} == 2'b10) ? 2 :
    //       3;

    // Similarly for rows (cd):
    // rows in order: 00,01,11,10
    // cd    row index
    // 0 0 -> 0
    // 0 1 -> 1
    // 1 1 -> 2
    // 1 0 -> 3

    // So row index:
    // if cd == 2'b00 -> 0
    // else if cd == 2'b01 -> 1
    // else if cd == 2'b11 -> 2
    // else -> 3

    // Now compute address = row_index * 4 + col_index
    // Then assign out from a 16-bit vector representing the K-map.

    // Calculate row index
    reg [1:0] row;
    reg [1:0] col;
    reg [3:0] addr;
    
    begin
        // compute row index
        case ({c,d})
            2'b00: row = 2'd0;
            2'b01: row = 2'd1;
            2'b11: row = 2'd2;
            2'b10: row = 2'd3;
            default: row = 2'd0; // should not occur
        endcase
        // compute col index
        case ({a,b})
            2'b01: col = 2'd0;
            2'b00: col = 2'd1;
            2'b10: col = 2'd2;
            2'b11: col = 2'd3;
            default: col = 2'd0; // should not occur
        endcase

        addr = row * 4 + col;

        // 16-bit vector corresponds to K-map entries with don't cares assigned:
        // Using the original table, assign don't cares to 0 for simplicity.
        // The K-map table flattened (row major: 4 rows x 4 cols):

        // row 0 (cd=00): d 0 1 1  => positions col0= d, col1=0, col2=1, col3=1
        // row 1 (cd=01): 0 0 d d  => col0=0, col1=0, col2=d, col3=d
        // row 2 (cd=11): 0 1 1 1  => col0=0, col1=1, col2=1, col3=1
        // row 3 (cd=10): 0 1 1 1  => col0=0, col1=1, col2=1, col3=1

        // For don't-cares 'd', we assign them to 0 for simplicity:

        // Index mapping:
        // addr = row*4 + col
        // bits [15:0] from addr=0..15
        // bit at position addr is output

        // Build bit pattern (bit 0 for addr=0, bit 15 for addr=15):

        // addr values and outputs:
        // addr=0 (row=0,col=0): d -> 0
        // addr=1 (row=0,col=1): 0
        // addr=2 (row=0,col=2): 1
        // addr=3 (row=0,col=3): 1

        // addr=4 (row=1,col=0): 0
        // addr=5 (row=1,col=1): 0
        // addr=6 (row=1,col=2): d -> 0
        // addr=7 (row=1,col=3): d -> 0

        // addr=8 (row=2,col=0): 0
        // addr=9 (row=2,col=1): 1
        // addr=10(row=2,col=2):1
        // addr=11(row=2,col=3):1

        // addr=12(row=3,col=0):0
        // addr=13(row=3,col=1):1
        // addr=14(row=3,col=2):1
        // addr=15(row=3,col=3):1

        // So the 16 bits (bit0 = addr0 output) = 
        // addr:output = bits:
        // 0:0
        // 1:0
        // 2:1
        // 3:1
        // 4:0
        // 5:0
        // 6:0
        // 7:0
        // 8:0
        // 9:1
        // 10:1
        // 11:1
        // 12:0
        // 13:1
        // 14:1
        // 15:1

        // Binary vector (LSB=addr0):
        // bit15 ... bit0 =
        // 15:1
        // 14:1
        // 13:1
        // 12:0
        // 11:1
        // 10:1
        // 9: 1
        // 8: 0
        // 7: 0
        // 6: 0
        // 5: 0
        // 4: 0
        // 3: 1
        // 2: 1
        // 1: 0
        // 0: 0

        // 16'b1110_1110_0000_1100

        case (addr)
            4'd0:  out = 1'b0;
            4'd1:  out = 1'b0;
            4'd2:  out = 1'b1;
            4'd3:  out = 1'b1;
            4'd4:  out = 1'b0;
            4'd5:  out = 1'b0;
            4'd6:  out = 1'b0;
            4'd7:  out = 1'b0;
            4'd8:  out = 1'b0;
            4'd9:  out = 1'b1;
            4'd10: out = 1'b1;
            4'd11: out = 1'b1;
            4'd12: out = 1'b0;
            4'd13: out = 1'b1;
            4'd14: out = 1'b1;
            4'd15: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
end

endmodule