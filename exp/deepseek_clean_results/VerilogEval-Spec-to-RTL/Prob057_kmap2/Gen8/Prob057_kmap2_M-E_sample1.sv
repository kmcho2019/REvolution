module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Hierarchical mux implementation of K-map
wire [3:0] row_select;
wire [3:0] col_data;

// Row selection based on cd
assign row_select = {c,d};

// Column data for each row
assign col_data[0] = (~a & ~b) ? 1'b1 :  // cd=00, ab=00
                    (~a & b)  ? 1'b1 :  // cd=00, ab=01
                    (a & b)   ? 1'b0 :  // cd=00, ab=11
                    1'b1;               // cd=00, ab=10

assign col_data[1] = (~a & ~b) ? 1'b1 :  // cd=01, ab=00
                    (~a & b)  ? 1'b0 :  // cd=01, ab=01
                    (a & b)   ? 1'b0 :  // cd=01, ab=11
                    1'b1;               // cd=01, ab=10

assign col_data[2] = (~a & ~b) ? 1'b0 :  // cd=11, ab=00
                    (~a & b)  ? 1'b1 :  // cd=11, ab=01
                    (a & b)   ? 1'b1 :  // cd=11, ab=11
                    1'b1;               // cd=11, ab=10

assign col_data[3] = (~a & ~b) ? 1'b1 :  // cd=10, ab=00
                    (~a & b)  ? 1'b1 :  // cd=10, ab=01
                    (a & b)   ? 1'b0 :  // cd=10, ab=11
                    1'b0;               // cd=10, ab=10

// Final output mux
assign out = (row_select == 2'b00) ? col_data[0] :
             (row_select == 2'b01) ? col_data[1] :
             (row_select == 2'b11) ? col_data[2] :
             col_data[3];

endmodule