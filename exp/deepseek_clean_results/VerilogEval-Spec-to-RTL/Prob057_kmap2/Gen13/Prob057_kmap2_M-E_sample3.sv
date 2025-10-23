module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for each cd case
wire out_cd00, out_cd01, out_cd11, out_cd10;

// Logic for cd=00 case (top row of K-map)
assign out_cd00 = (a & b) ? 1'b0 : 1'b1;

// Logic for cd=01 case (second row of K-map)
assign out_cd01 = (!a & b) ? 1'b0 : 1'b1;

// Logic for cd=11 case (third row of K-map)
assign out_cd11 = (!a & !b) ? 1'b0 : 
                  (a & !b) ? 1'b1 : 
                  (a & b) ? 1'b1 : 1'b0;

// Logic for cd=10 case (bottom row of K-map)
assign out_cd10 = (a & b) ? 1'b0 : 
                  (a & !b) ? 1'b0 : 1'b1;

// Final 4:1 mux using cd as select
assign out = (!c & !d) ? out_cd00 :
             (!c & d)  ? out_cd01 :
             (c & d)   ? out_cd11 :
             out_cd10;

endmodule