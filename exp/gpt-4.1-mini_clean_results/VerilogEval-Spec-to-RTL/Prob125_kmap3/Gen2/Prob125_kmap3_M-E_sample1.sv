module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care
    output out
);

wire s0 = a; // select bit 0
wire s1 = b; // select bit 1

// Data inputs for 4:1 MUX indexed by {b,a}
wire d0; // input when b=0,a=0
wire d1; // input when b=0,a=1
wire d2; // input when b=1,a=0
wire d3; // input when b=1,a=1

// Based on Karnaugh map rows of ab (00,01,10,11):
// We'll map inputs as follows:
// ab=00 (b=0,a=0): d0 = from K-map entries for ab=00 → rows cd=00..11: 0,0,1,1 → we pick majority or use c to select between
// ab=01 (b=0,a=1): d1 = 0,0,d,d → choose 0 for simplicity
// ab=10 (b=1,a=0): d2 = 1, d,1,1 → pick 1 for simplicity
// ab=11 (b=1,a=1): d3 = 1, d,1,1 → pick 1 for simplicity

// To approximate c dependency where needed, assign:
assign d0 = c;      // for ab=00, out=1 when c=1 (cd=10,11)
assign d1 = 1'b0;   // ab=01, mostly 0 or don't care, select 0
assign d2 = 1'b1;   // ab=10, mostly 1's
assign d3 = 1'b1;   // ab=11, mostly 1's

// 4-to-1 MUX
assign out = (s1 == 0 && s0 == 0) ? d0 :
             (s1 == 0 && s0 == 1) ? d1 :
             (s1 == 1 && s0 == 0) ? d2 :
             d3;

endmodule