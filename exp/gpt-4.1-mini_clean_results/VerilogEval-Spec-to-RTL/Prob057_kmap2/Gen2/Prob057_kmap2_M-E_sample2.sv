module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Map ab to column index according to K-map order: 00->0, 01->1, 11->3, 10->2
// Using a function-like expression:
wire [1:0] ab_val = {a,b};
wire [1:0] col_index;

assign col_index = (ab_val == 2'b00) ? 2'd0 :
                   (ab_val == 2'b01) ? 2'd1 :
                   (ab_val == 2'b11) ? 2'd3 :
                   /* ab_val == 10 */ 2'd2;

// Row index is cd in binary order (00=0,01=1,11=3,10=2)
wire [1:0] row_index = {c,d};

// K-map 16-bit vector in row-major order (rows: cd=00,01,11,10; cols in above order):
// From table:
// cd\ab 00 01 11 10
// 00    1  1  0  1
// 01    1  0  0  1
// 11    0  1  1  1
// 10    1  1  0  0
//
// Flattening:
// row 0: bits [0..3] = 1 1 0 1 (cols 0 to 3)
// row 1: bits [4..7] = 1 0 0 1
// row 2: bits [8..11]= 0 1 1 1
// row 3: bits [12..15]=1 1 0 0

localparam [15:0] KMAP = 16'b1101_1001_0111_1100;

wire [3:0] index = row_index*4 + col_index;

assign out = KMAP[index];

endmodule