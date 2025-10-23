module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate mux outputs for each cd case
wire mux00_out, mux01_out, mux11_out, mux10_out;

// First level muxes (each handles ab for fixed cd)
assign mux00_out = (~a & ~b) ? 1'b1 :  // ab=00
                   (~a &  b) ? 1'b1 :  // ab=01
                   ( a &  b) ? 1'b0 :  // ab=11
                               1'b1;   // ab=10

assign mux01_out = (~a & ~b) ? 1'b1 :  // ab=00
                   (~a &  b) ? 1'b0 :  // ab=01
                   ( a &  b) ? 1'b0 :  // ab=11
                               1'b1;   // ab=10

assign mux11_out = (~a & ~b) ? 1'b0 :  // ab=00
                   (~a &  b) ? 1'b1 :  // ab=01
                   ( a &  b) ? 1'b1 :  // ab=11
                               1'b1;   // ab=10

assign mux10_out = (~a & ~b) ? 1'b1 :  // ab=00
                   (~a &  b) ? 1'b1 :  // ab=01
                   ( a &  b) ? 1'b0 :  // ab=11
                               1'b0;   // ab=10

// Final output mux (selects based on cd)
assign out = (~c & ~d) ? mux00_out :  // cd=00
             (~c &  d) ? mux01_out :  // cd=01
             ( c &  d) ? mux11_out :  // cd=11
                         mux10_out;   // cd=10

endmodule