module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the SOP expression
assign out_sop = (a == 0 && b == 1 && c == 0 && d == 0) || // 2
                 (a == 0 && b == 1 && c == 1 && d == 1) || // 7
                 (a == 1 && b == 1 && c == 1 && d == 1);  // 15

// Define the POS expression
assign out_pos = ~( (a == 0 && b == 0 && c == 0 && d == 0) || // 0
                    (a == 0 && b == 0 && c == 0 && d == 1) || // 1
                    (a == 0 && b == 1 && c == 0 && d == 0) || // 4
                    (a == 0 && b == 1 && c == 0 && d == 1) || // 5
                    (a == 0 && b == 1 && c == 1 && d == 0) || // 6
                    (a == 1 && b == 0 && c == 0 && d == 1) || // 9
                    (a == 1 && b == 0 && c == 1 && d == 0) || // 10
                    (a == 1 && b == 1 && c == 0 && d == 1) || // 13
                    (a == 1 && b == 1 && c == 1 && d == 0) ); // 14

endmodule