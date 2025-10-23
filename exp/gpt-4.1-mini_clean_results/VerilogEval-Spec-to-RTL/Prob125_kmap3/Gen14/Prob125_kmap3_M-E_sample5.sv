module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care, unused
    output out
);

wire [1:0] sel = {a,b};

// Outputs for c=0 (rows 00 and 01):
// cd=00 and 01 with d=0 or 1 depending on sel:
// sel=00 (a=0,b=0):  c=0, row 00-> cell is 0
// sel=01 (a=0,b=1):  c=0, row 00-> cell is d (don't care), choose 0 here
// sel=10 (a=1,b=0):  c=0, row 00-> cell is 1
// sel=11 (a=1,b=1):  c=0, row 00-> cell is 1
// For row 01, values are 0 except d (don't care)
// We'll define c0_out using a 4-to-1 mux for sel

wire c0_out = (sel == 2'b00) ? 1'b0 :
              (sel == 2'b01) ? 1'b0 : // chose 0 for don't care
              (sel == 2'b10) ? 1'b1 :
              (sel == 2'b11) ? 1'b1 : 1'b0;

// Outputs for c=1 (rows 10 and 11):
// For c=1 and sel:
// sel=00: row 10 col 00 = 0
// sel=01: row 10 col 01 = 1
// sel=10: row 10 col 10 = 1
// sel=11: row 10 col 11 = 1
// row 11 col 00=0, col 01=1, col 10=1, col11=1
// Because the last two rows are same for sel=01-11, use the same mapping
wire c1_out = (sel == 2'b00) ? 1'b0 :
              (sel == 2'b01) ? 1'b1 :
              (sel == 2'b10) ? 1'b1 :
              (sel == 2'b11) ? 1'b1 : 1'b0;

// Final output selects between c0_out and c1_out based on c
assign out = c ? c1_out : c0_out;

endmodule